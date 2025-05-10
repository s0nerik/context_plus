import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils.dart';

class ConvertToTopLevelRefAssist extends DartAssist {
  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) async {
    final resolvedUnitResult = await resolver.getResolvedUnitResult();
    if (!resolvedUnitResult.exists) return;
    final unit = resolvedUnitResult.unit;

    context.registry.addFieldDeclaration((node) {
      // Check if the assist target is within this method invocation
      if (!target.intersects(node.sourceRange)) {
        return;
      }

      if (!node.isStatic) {
        return;
      }

      final type = node.fields.variables.firstOrNull?.declaredElement?.type;
      if (!isRef(type)) {
        return;
      }

      final refName = createProposedTopLevelRefName(
        unit: unit,
        returnType: type?.genericTypeArgument,
        assignedVariableName: node.fields.variables.firstOrNull?.name.lexeme,
      );

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Convert to top-level Ref: $refName',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        // 1. Create the Ref declaration
        createNewTopLevelRefDeclaration(
          unit: unit,
          builder: builder,
          refName: refName,
          type: type?.genericTypeArgument,
        );

        // 2. Remove old field declaration
        builder.addDeletion(node.sourceRange);
      });
    });
  }
}
