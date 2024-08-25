import itertools
import os
import shutil
import textwrap

type_values = {
    'Listenable': 'void',
    'ValueListenable<T>': 'T',
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
    return_types = []
    for i, type in enumerate(perm):
        ext_generic_type = None
        if '<' in type:
            ext_generic_type = type[type.index('<') + 1:type.index('>')]
            ext_generic_type = ext_generic_type.replace('T', f'T{i}')
        ext_generic_types.append(ext_generic_type)
        ext_on_types.append(type.replace('<T>', f'<T{i}>'))

        return_type = type_values[type]
        if return_type == 'T':
            return_types.append(f'T{i}')
        else:
            return_types.append(return_type.replace('<T>', f'<T{i}>'))

    generics = ', '.join(t for t in ext_generic_types if t)
    on = ', '.join(ext_on_types)
    if len(ext_on_types) == 1:
        on += ','
    return_record = ', '.join(return_types)
    if len(perm) == 1:
        return_record += ','

    def watch(i, type):
        ret = type_values[type]
        if ret == 'void':
            return f'${i + 1}.watch(context) as Null'
        return f'${i + 1}.watch(context)'

    extensions.append(textwrap.dedent(f'''
        /// More convenient API for watching multiple values at once.
        extension ContextWatchRecordExt{perm_index}{f'<{generics}>' if generics else ''} on ({on}) {{
          /// {{@macro mass_watch_explanation}}
          ({return_record}) watch(BuildContext context) =>
              ({', '.join(watch(i, type) for i, type in enumerate(perm))},);
        }}
    ''').strip())

combinations_dir_path = '../packages/context_watch/lib/src/watch_record_combinations'
shutil.rmtree(combinations_dir_path, ignore_errors=True)
os.mkdir(combinations_dir_path)


def watch_record_file_name(i):
    return f'watch_record_combination_{i + 1}.dart'


# write all extensions into separate files
for i, ext in enumerate(extensions):
    with open(f'{combinations_dir_path}/{watch_record_file_name(i)}', 'w+') as file:
        file.write('// ignore_for_file: use_of_void_result\n\n')

        has_listenable = 'Listenable' in ext
        has_value_listenable = 'ValueListenable<' in ext
        has_async_listenable = 'AsyncListenable<' in ext
        has_stream = 'Stream<' in ext
        has_future = 'Future<' in ext

        # Order of imports is important, don't change it
        needs_newline_after_package_imports = False
        if has_async_listenable:
            file.write("import 'package:async_listenable/async_listenable.dart';\n")
            needs_newline_after_package_imports = True
        if has_value_listenable:
            file.write("import 'package:flutter/foundation.dart';\n")
            needs_newline_after_package_imports = True
        file.write("import 'package:flutter/widgets.dart';\n")
        file.write('\n')

        # Order of imports is important, don't change it
        needs_newline_after_relative_imports = False
        if has_future:
            file.write("import '../watchers/future_context_watcher.dart';\n")
            needs_newline_after_relative_imports = True
        if has_listenable or has_value_listenable or has_async_listenable:
            file.write("import '../watchers/listenable_context_watcher.dart';\n")
            needs_newline_after_relative_imports = True
        if has_stream:
            file.write("import '../watchers/stream_context_watcher.dart';\n")
            needs_newline_after_relative_imports = True
        if needs_newline_after_relative_imports:
            file.write('\n')

        file.write(ext)
        file.write('\n')

# create an export file
with open('../packages/context_watch/lib/src/watch_record_combinations.dart', 'w+') as file:
    file.write(textwrap.dedent('''
        /// {@template mass_watch_explanation}
        /// Watch all observables for changes.
        ///
        /// Whenever any observable notifies of a change, the [context] will
        /// be rebuilt.
        ///
        /// Returns current values for each observable.
        ///
        /// It is safe to call this method multiple times within the same build
        /// method.
        /// {@endtemplate}
    ''').strip())
    file.write('\n')
    file.write('library;')
    file.write('\n\n')
    for i, ext in enumerate(extensions):
        file.write(f"export 'watch_record_combinations/{watch_record_file_name(i)}';\n")
