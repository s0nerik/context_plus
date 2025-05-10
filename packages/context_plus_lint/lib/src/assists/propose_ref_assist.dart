import 'package:analyzer/source/source_range.dart';
import 'package:context_plus_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ProposeRefAssist extends DartAssist {
  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target, // The SourceRange where the assist is invoked
  ) async {
    final resolvedUnitResult = await resolver.getResolvedUnitResult();
    if (!resolvedUnitResult.exists) return;
    final unit = resolvedUnitResult.unit;

    addContextUseInvocationVisitor(context.registry, (useInfo) {
      final node = useInfo.node;

      // Check if the assist target is within this method invocation
      if (!target.intersects(node.sourceRange)) {
        return;
      }

      if (useInfo.key.refSource != null) {
        return;
      }

      final refName = createProposedTopLevelRefName(
        unit: unit,
        returnType: useInfo.returnType,
        assignedVariableName: useInfo.assignedVariableName,
      );

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Bind to a new Ref: $refName',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        // 1. Create the Ref declaration
        createNewTopLevelRefDeclaration(
          unit: unit,
          builder: builder,
          refName: refName,
          type: useInfo.returnType,
        );

        // 2. Add the ref: argument to context.use()
        useInfo.addOrReplaceRefArgument(
          resolver: resolver,
          builder: builder,
          refName: refName,
        );
      });
    });
  }
}
