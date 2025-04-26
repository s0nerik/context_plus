import os
import shutil
import textwrap

from record_type_combinations import RecordTypeCombination

extensions = []

for c in RecordTypeCombination.generate():
    extensions.append(f'''
/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt{c.index}{c.generic_types_str} on ({c.types_in_str}) {{
  /// {{@macro mass_watch_only_explanation}}
  R watchOnly<R>(
    BuildContext context,
    R Function({c.types_out_str}) selector,
  ) {{
    return watchOnly{len(c.types_out)}<R, {c.types_out_str}, {c.obs_types_str}>(context, selector, {c.record_params_str}, {c.default_selector_values_str});
  }}

  /// {{@macro mass_watch_effect_explanation}}
  void watchEffect(
    BuildContext context,
    void Function({c.types_out_str}) effect, {{
    Object? key,
    bool immediate = false,
    bool once = false,
  }}) {{
    return watchEffect{len(c.types_out)}<{c.types_out_str}, {c.obs_types_str}>(context, effect, {c.record_params_str}, key: key, immediate: immediate, once: once);
  }}
  
  /// {{@macro mass_unwatch_effect_explanation}}
  void unwatchEffect(BuildContext context, {{required Object key}}) {{
    return unwatchEffect{len(c.types_out)}(context, {c.record_params_str}, key: key);
  }}
}}
    '''.strip())

name = 'watch_callback_record_combinations'
dir_path = f'../packages/context_watch/lib/src/api/{name}'
shutil.rmtree(dir_path, ignore_errors=True)
os.mkdir(dir_path)


def file_name(i):
    return f'watch_callback_record_combination_{i}.dart'


# write all extensions into separate files
for i, ext in enumerate(extensions):
    with open(f'{dir_path}/{file_name(i)}', 'w+') as file:
        # Order of imports is important, don't change it
        file.write("import 'package:context_watch_base/watch_callback_record_util.dart';\n")
        if 'ValueListenable' in ext:
            file.write("import 'package:flutter/foundation.dart';\n")
        file.write("import 'package:flutter/widgets.dart';\n")
        file.write('\n')
        file.write(ext)
        file.write('\n')

# create an export file
with open(f'../packages/context_watch/lib/src/api/{name}.dart', 'w+') as file:
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
        file.write(f"export '{name}/{file_name(i)}';\n")
