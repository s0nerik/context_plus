import itertools
import os
import shutil
import textwrap

from record_type_combinations import RecordTypeCombination

extensions = []

for c in RecordTypeCombination.generate():
    on_type = '(' + ', '.join([f'context_ref.ReadOnlyRef<{t}>' for t in c.types_in]) + ')';
    extensions.append(textwrap.dedent(f'''
        /// More convenient API for watching multiple values at once.
        extension ContextWatchRecordRefExt{c.index}{c.generic_types_str} on {on_type} {{
          /// {{@macro mass_watch_explanation}}
          ({c.types_out_str}) watch(BuildContext context) =>
              ({', '.join(f'${i + 1}.of(context).watch(context)' for i in range(len(c.types_in)))},);
        }}
    ''').strip())

name = 'watch_record_combinations'
combinations_dir_path = f'../packages/context_plus/lib/src/{name}'
shutil.rmtree(combinations_dir_path, ignore_errors=True)
os.mkdir(combinations_dir_path)


def watch_record_file_name(i):
    return f'watch_record_combination_{i}.dart'


# write all extensions into separate files
for i, ext in enumerate(extensions):
    with open(f'{combinations_dir_path}/{watch_record_file_name(i)}', 'w+') as file:
        has_listenable = 'Listenable' in ext
        has_value_listenable = 'ValueListenable<' in ext

        # Order of imports is important, don't change it
        file.write("import 'package:context_ref/context_ref.dart' as context_ref;\n")
        file.write("import 'package:context_watch/context_watch.dart' as context_watch;\n")
        if has_value_listenable:
            file.write("import 'package:flutter/foundation.dart';\n")
            needs_newline_after_package_imports = True
        file.write("import 'package:flutter/widgets.dart';\n")
        file.write('\n')
        file.write(ext)
        file.write('\n')

# create an export file
with open(f'../packages/context_plus/lib/src/{name}.dart', 'w+') as file:
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
        file.write(f"export '{name}/{watch_record_file_name(i)}';\n")
