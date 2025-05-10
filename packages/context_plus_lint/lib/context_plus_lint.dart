import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/convert_to_top_level_ref_assist.dart';
import 'src/assists/propose_ref_assist.dart';
import 'src/lints/context_ref_reassignment_lint.dart';
import 'src/lints/context_use_key_parameters_lint.dart';
import 'src/lints/wrong_ref_declaration_lint.dart';
import 'src/lints/wrong_ref_type_lint.dart';

PluginBase createPlugin() => _ContextPlusLinter();

class _ContextPlusLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => const [
    ContextUseUniqueKeyLint(),
    ContextRefReassignmentLint(),
    WrongRefDeclarationLint(),
    WrongRefTypeLint(),
  ];

  @override
  List<Assist> getAssists() => [
    ProposeRefAssist(),
    ConvertToTopLevelRefAssist(),
  ];
}
