import itertools
import os
import shutil
import textwrap

type_values = {
    'Listenable': 'TListenable',
    'Future<T>': 'AsyncSnapshot<T>',
    'Stream<T>': 'AsyncSnapshot<T>',
}

# all possible permutations (with repetitions) of the watch record for up to 4 values
permutations = []
for r in range(2, 5):
    permutations.extend(list(itertools.product(type_values.keys(), repeat=r)))

extensions = []
perm_index = 0

for perm in permutations:
    perm_index += 1
    ext_generic_types = []
    ext_on_types = []
    callback_arg_types = []
    for i, type in enumerate(perm):
        ext_generic_type = None
        if '<' in type:
            ext_generic_type = type[type.index('<') + 1:type.index('>')]
            ext_generic_type = ext_generic_type.replace('T', f'T{i + 1}')
        if not ext_generic_type and type == 'Listenable':
            ext_generic_type = f'TListenable{i + 1} extends Listenable'
        ext_generic_types.append(ext_generic_type)
        if type == 'Listenable':
            ext_on_types.append(f"context_ref.ReadOnlyRef<TListenable{i + 1}>")
        else:
            ext_on_types.append(f"context_ref.ReadOnlyRef<{type.replace('<T>', f'<T{i + 1}>')}>")

        callback_arg_type = type_values[type]
        if callback_arg_type == 'TListenable':
            callback_arg_types.append(f'TListenable{i + 1}')
        else:
            callback_arg_types.append(callback_arg_type.replace('<T>', f'<T{i + 1}>'))

    generics = ', '.join(t for t in ext_generic_types if t)
    on = ', '.join(ext_on_types)
    if len(ext_on_types) == 1:
        on += ','
    arg_types = ', '.join(callback_arg_types)


    def arg_type(i, type):
        t = type_values[type]
        if t == 'TListenable':
            return f'TListenable{i + 1}'
        return t.replace('<T>', f'<T{i + 1}>')


    def watch_only_default_selector_args(perm):
        args = []
        for i, type in enumerate(perm):
            if type == 'Listenable':
                args.append(f'${i + 1}.of(context)')
            elif type == 'Future<T>' or type == 'Stream<T>':
                args.append(f'AsyncSnapshot<T{i + 1}>.nothing()')
        return ', '.join(args)


    def watch_only_fetch_arg(i, type, perm):
        if type == 'Listenable':
            arg_type_generic = ''
        else:
            arg_type_generic = f'<T{i + 1}>'
        lines = []
        if i == 0:
            lines.append(
                f'final observable{i + 1} = contextWatch.getOrCreateObservable{arg_type_generic}(context, ${i + 1});')
            lines.append(
                f'if (observable{i + 1} == null) return selector({watch_only_default_selector_args(perm)});')
        else:
            lines.append(
                f'final observable{i + 1} = contextWatch.getOrCreateObservable{arg_type_generic}(context, ${i + 1})!;')
        lines.append(
            f'final arg{i + 1} = observable{i + 1}.subscription.callbackArgument as {arg_type(i, type)};')
        return '\n    '.join(lines)


    def watch_only_watch_args():
        lines = [
            f'final selectedValue = selector({', '.join([f'arg{i + 1}' for i in range(len(perm))])});'
        ]
        for i, _ in enumerate(perm):
            lines.append(f'observable{i + 1}.watchOnly(')
            lines.append(f'  (arg{i + 1}) => selector(')
            for j, type in enumerate(perm):
                if j == i:
                    lines.append(f'    arg{j + 1},')
                else:
                    result_type = type_values[type]
                    if result_type == 'TListenable':
                        result_type = f'TListenable{j + 1}'
                    else:
                        result_type = result_type.replace('<T>', f'<T{j + 1}>')
                    lines.append(
                        f'    observable{j + 1}.subscription.callbackArgument as {result_type},')
            lines.append(f'  ),')
            lines.append(f'  selectedValue,')
            lines.append(f');')
        return '\n    '.join(lines)


    def watch_effect_fetch_observable(i, type):
        if type == 'Listenable':
            arg_type_generic = ''
        else:
            arg_type_generic = f'<T{i + 1}>'
        lines = []
        if i == 0:
            lines.append(
                f'final obs{i + 1} = contextWatch.getOrCreateObservable{arg_type_generic}(context, ${i + 1}.of(context));')
            lines.append(
                f'if (obs{i + 1} == null) return;')
        else:
            lines.append(
                f'final obs{i + 1} = contextWatch.getOrCreateObservable{arg_type_generic}(context, ${i + 1}.of(context))!;')
        return '\n    '.join(lines)


    def watch_effect_watch_args():
        def append_remaining_args(lines, effect_index):
            for i, type in enumerate(perm):
                if i == effect_index:
                    continue
                else:
                    result_type = type_values[type]
                    if result_type == 'TListenable':
                        result_type = f'TListenable{i + 1}'
                    else:
                        result_type = result_type.replace('<T>', f'<T{i + 1}>')
                    lines.append(
                        f'  final arg{i + 1} = obs{i + 1}.subscription.callbackArgument as {result_type};')

        lines = []
        for i, _ in enumerate(perm):
            lines.append(f'obs{i + 1}.watchEffect((arg{i + 1}) {{')
            observables = ', '.join([f'obs{j + 1}' for j in range(len(perm))])
            lines.append(f'  if (shouldAbortMassEffect{len(perm)}(key, {observables},')
            lines.append(f'      once: once, immediate: immediate)) {{')
            lines.append(f'    return;')
            lines.append(f'  }}')
            append_remaining_args(lines, i)
            all_args = ', '.join([f'arg{j + 1}' for j in range(len(perm))])
            lines.append(f'  effect({all_args});')
            lines.append('}, key: key, immediate: immediate, once: once);')
        return '\n    '.join(lines)


    def unwatch_effect_calls():
        lines = []
        for i, _ in enumerate(perm):
            lines.append(f'contextWatch.unwatchEffect(context, ${i + 1}.of(context), key);')
        return '\n    '.join(lines)


    extensions.append(f'''
/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt{perm_index}{f'<{generics}>' if generics else ''} on ({on}) {{
  /// {{@macro mass_watch_only_explanation}}
  R watchOnly<R>(
    BuildContext context,
    R Function({arg_types}) selector,
  ) {{
    final contextWatch = InheritedContextWatch.of(context);
    
    {'\n\n    '.join(watch_only_fetch_arg(i, type, perm) for i, type in enumerate(perm))}
    
    {watch_only_watch_args()}
    
    return selectedValue;
  }}

  /// {{@macro mass_watch_effect_explanation}}
  void watchEffect(
    BuildContext context,
    void Function({arg_types}) effect, {{
    Object? key,
    bool immediate = false,
    bool once = false,
  }}) {{
    final contextWatch = InheritedContextWatch.of(context);
    
    {'\n    '.join(watch_effect_fetch_observable(i, type) for i, type in enumerate(perm))}
    
    {watch_effect_watch_args()}
  }}
  
  /// {{@macro mass_unwatch_effect_explanation}}
  void unwatchEffect(BuildContext context, {{required Object key}}) {{
    final contextWatch = InheritedContextWatch.of(context);
    
    {unwatch_effect_calls()}
  }}
}}
    '''.strip())

dir_name = 'watch_callback_record_combinations'
dir_path = f'../packages/context_plus/lib/src/{dir_name}'
shutil.rmtree(dir_path, ignore_errors=True)
os.mkdir(dir_path)


def file_name(i):
    return f'watch_callback_record_combination_{i + 1}.dart'


# write all extensions into separate files
for i, ext in enumerate(extensions):
    with open(f'{dir_path}/{file_name(i)}', 'w+') as file:
        file.write('// ignore_for_file: use_of_void_result\n\n')

        has_value_listenable = 'ValueListenable<' in ext

        # Order of imports is important, don't change it
        file.write("import 'package:context_ref/context_ref.dart' as context_ref;\n")
        file.write("import 'package:context_watch_base/context_watch_base.dart';\n")
        file.write("import 'package:context_watch_base/watch_callback_record_util.dart';\n")
        if has_value_listenable:
            file.write("import 'package:flutter/foundation.dart';\n")
            needs_newline_after_package_imports = True
        file.write("import 'package:flutter/widgets.dart';\n")
        file.write('\n')
        file.write(ext)
        file.write('\n')

# create an export file
with open('../packages/context_plus/lib/src/watch_callback_record_combinations.dart', 'w+') as file:
    file.write(textwrap.dedent('''
        /// {@template mass_watch_only_explanation}
        /// Watch all observables for changes.
        ///
        /// Whenever any observable notifies of a change, the [selector] will be
        /// called with the latest values of all observables. If the [selector]
        /// returns a different value, the [context] will be rebuilt.
        ///
        /// Returns the value provided by [selector].
        ///
        /// It is safe to call this method multiple times within the same build
        /// method.
        /// {@endtemplate}
        ///
        /// {@template mass_watch_effect_explanation}
        /// Watch all observables for changes.
        ///
        /// Whenever any observable notifies of a change, the [effect] will be
        /// called with the latest values of all observables, *without* rebuilding the widget.
        ///
        /// Conditional effects are supported, but it's highly recommended to specify
        /// a unique [key] for all such effects followed by the [unwatchEffect] call
        /// when condition is no longer met:
        /// ```dart
        /// if (condition) {
        ///   (listenable, stream, future).watchEffect(context, key: 'effect', (_, _, _) {...});
        /// } else {
        ///   (listenable, stream, future).unwatchEffect(context, key: 'effect');
        /// }
        /// ```
        ///
        /// If [immediate] is `true`, the effect will be called upon effect
        /// registration immediately. If [once] is `true`, the effect will be called
        /// only once. These parameters can be combined.
        ///
        /// [immediate] and [once] parameters require a unique [key].
        /// {@endtemplate}
        ///
        /// {@template mass_unwatch_effect_explanation}
        /// Remove the effect with the given [key] from the list of effects to be
        /// called when any of referenced observables notifies of a change.
        /// {@endtemplate}
    ''').strip())
    file.write('\n')
    file.write('library;')
    file.write('\n\n')
    for i, ext in enumerate(extensions):
        file.write(f"export '{dir_name}/{file_name(i)}';\n")
