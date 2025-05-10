import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:context_plus_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ContextRefReassignmentLint extends DartLintRule {
  const ContextRefReassignmentLint() : super(code: _code);

  static const _code = LintCode(
    name: 'context_ref_reassignment',
    problemMessage:
        'A Ref instance cannot be bound multiple times within the same build method.',
    correctionMessage:
        'Ensure each Ref is bound only once or use different Refs.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    addBuildMethodVisitor(context.registry, (node) {
      final boundRefsInThisBuild = HashSet<String>();
      node.body.accept(
        RecursiveInvocationExpressionVisitor((node) {
          final useInfo = ContextUseInfo.fromInvocation(node);
          if (useInfo != null) {
            final ref = useInfo.key.refSource;
            if (boundRefsInThisBuild.contains(ref)) {
              reporter.atNode(node, _code);
            } else if (ref != null) {
              boundRefsInThisBuild.add(ref);
            }
            return;
          }

          final refBindExpression = RefBindExpression.fromInvocation(node);
          if (refBindExpression != null) {
            final ref = refBindExpression.ref.toSource();
            if (boundRefsInThisBuild.contains(ref)) {
              reporter.atNode(node, _code);
            } else {
              boundRefsInThisBuild.add(ref);
            }
          }
        }),
      );
    });
  }

  @override
  List<Fix> getFixes() => [_Fix()];
}

class _Fix extends DartFix {
  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError error,
    List<AnalysisError> others,
  ) async {
    final resolvedUnitResult = await resolver.getResolvedUnitResult();
    if (!resolvedUnitResult.exists) return;
    final unit = resolvedUnitResult.unit;

    final invocation = findErrorNode<InvocationExpression>(unit, error);
    if (invocation == null) {
      return;
    }

    final useInfo = ContextUseInfo.fromInvocation(invocation);
    final refBindExpression = RefBindExpression.fromInvocation(invocation);

    final ref = useInfo?.refIdentifier ?? refBindExpression?.refIdentifier;
    if (ref == null) {
      return;
    }

    final assignedVariableName =
        useInfo?.assignedVariableName ??
        refBindExpression?.assignedVariableName;
    final returnType = useInfo?.returnType ?? refBindExpression?.returnType;
    final originalRefName = ref.name;

    final refName = createProposedTopLevelRefName(
      unit: unit,
      returnType: returnType,
      assignedVariableName: assignedVariableName,
      originalRefName: originalRefName,
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
        type: returnType,
      );

      // 2.1. Add the `ref:` argument to context.use()
      useInfo?.addOrReplaceRefArgument(
        resolver: resolver,
        builder: builder,
        refName: refName,
      );

      // 2.2. Replace the Ref target
      refBindExpression?.replaceRefTarget(builder: builder, refName: refName);
    });
  }
}
