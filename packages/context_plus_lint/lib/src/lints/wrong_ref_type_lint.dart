import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils.dart';

class WrongRefTypeLint extends DartLintRule {
  const WrongRefTypeLint() : super(code: _code);

  static const _code = LintCode(
    name: 'wrong_ref_type',
    problemMessage:
        'The Ref type does not match the return type of the context.use() call.',
    correctionMessage:
        'Update the Ref generic type to match the return type of the context.use() call.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    addContextUseInvocationVisitor(context.registry, (useInfo) {
      final refExpr = useInfo.refExpression;
      if (refExpr == null) return;

      // Get the ref's expression and its type
      final refGenericType = refExpr.staticType?.genericTypeArgument;
      if (refGenericType == null) return;

      // Check if the ref's type argument matches the context.use return type
      if (!refGenericType.isAssignableFromType(useInfo.returnType)) {
        reporter.atNode(refExpr, _code);
      }
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
    if (!resolvedUnitResult.exists) return print('!resolvedUnitResult.exists');
    final unit = resolvedUnitResult.unit;

    final namedRefExpr = findErrorNode<NamedExpression>(unit, error);
    if (namedRefExpr == null) return print('refExpr == null');

    final refIdentifier = namedRefExpr.expression.unParenthesized;
    if (refIdentifier is! SimpleIdentifier)
      return print('refExpr is! SimpleIdentifier');

    final refDeclaration = findTopLeveleOrStaticVariableDeclaration(
      unit,
      refIdentifier,
    );
    if (refDeclaration == null) return print('refDeclaration == null');

    // Find the context.use invocation to get its return type
    final invocation =
        namedRefExpr.thisOrAncestorOfType<InvocationExpression>();
    if (invocation == null) return print('invocation == null');

    final contextUseInfo = ContextUseInfo.fromInvocation(invocation);
    if (contextUseInfo == null) return print('contextUseInfo == null');

    final correctTypeName = contextUseInfo.returnTypeName;

    final initializer = refDeclaration.initializer;
    if (initializer == null) return print('initializer == null');
    if (initializer is! InstanceCreationExpression)
      return print('initializer is! InstanceCreationExpression');

    final constructorName = initializer.constructorName;
    final constructorTypeIdentifier = constructorName.type;

    // Check if it's a Ref instance
    if (constructorTypeIdentifier.name2.lexeme == 'Ref') {
      // Create a change builder for fixing the Ref type
      final builder = reporter.createChangeBuilder(
        message: 'Change ${refIdentifier.name} type to Ref<$correctTypeName>',
        priority: 80,
      );

      builder.addDartFileEdit((dartFileEditBuilder) {
        // Check if it already has type arguments
        if (constructorTypeIdentifier.typeArguments != null) {
          // Replace existing type arguments
          dartFileEditBuilder.addReplacement(
            constructorTypeIdentifier.typeArguments!.sourceRange,
            (editor) => editor.write('<$correctTypeName>'),
          );
        } else {
          // Add type arguments if none exist
          dartFileEditBuilder.addSimpleInsertion(
            constructorTypeIdentifier.end,
            '<$correctTypeName>',
          );
        }
      });
    }
  }
}
