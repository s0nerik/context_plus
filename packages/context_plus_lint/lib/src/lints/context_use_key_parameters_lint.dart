import 'dart:collection';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils.dart';

class ContextUseUniqueKeyLint extends DartLintRule {
  const ContextUseUniqueKeyLint() : super(code: _code);

  static const _code = LintCode(
    name: 'context_use_unique_key',
    problemMessage:
        'Each context.use() call for a given BuildContext must have a different combination of return type, `key` and `ref` parameters within the same build method.',
    correctionMessage:
        'Ensure that this combination of return type, key, and ref is unique within this build method or widget.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    addBuildMethodVisitor(context.registry, (node) {
      final useKeysInThisBuild = HashSet<ContextUseKey>();
      node.body.accept(
        RecursiveContextUseInvocationsVisitor((useInfo) {
          if (useKeysInThisBuild.contains(useInfo.key)) {
            reporter.atNode(useInfo.node, _code);
          } else {
            useKeysInThisBuild.add(useInfo.key);
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

    final visitor = _InvocationExpressionFinder(error.offset, error.length);
    resolvedUnitResult.unit.accept(visitor);
    final invocationNode = visitor.foundNode;
    if (invocationNode == null) {
      return;
    }

    final useInfo = ContextUseInfo.fromInvocation(invocationNode);
    if (useInfo == null) {
      return;
    }

    final buildMethodBody = invocationNode.thisOrAncestorOfType<FunctionBody>();
    if (buildMethodBody == null) {
      // Should be within a function body
      return;
    }

    // --- Rebuild effectiveSeenUseKeys ---
    final effectiveSeenUseKeys = <ContextUseKey>{};
    buildMethodBody.accept(
      RecursiveContextUseInvocationsVisitor((useInfo) {
        final inv = useInfo.node;
        // Only consider invocations that appear strictly before the node we're fixing.
        // And ensure it's not the same node if offsets were identical for some reason.
        if (inv.offset < invocationNode.offset ||
            (inv.offset == invocationNode.offset &&
                inv.length < invocationNode.length)) {
          final key = ContextUseKey.fromInvocation(inv);
          if (key != null) {
            effectiveSeenUseKeys.add(key);
          }
        }
      }),
    );
    // --- End of rebuilding effectiveSeenUseKeys ---

    /// --- Try to find a new key source code ---

    String? newKeyStringLiteral;

    // 1. Try to use variable name if applicable and unique
    final variableName = useInfo.assignedVariableName;
    if (variableName != null) {
      final proposedKey = useInfo.key.copyWithStringLiteralKey(variableName);
      if (!effectiveSeenUseKeys.contains(proposedKey)) {
        newKeyStringLiteral = variableName;
      }
    }

    // 2. If no suitable variable name key, generate 'ReturnType'
    if (newKeyStringLiteral == null) {
      final typeName = useInfo.returnTypeName;
      final proposedKey = useInfo.key.copyWithStringLiteralKey(typeName);
      if (!effectiveSeenUseKeys.contains(proposedKey)) {
        newKeyStringLiteral = typeName;
      }
    }

    // 3. If no suitable variable name key, generate 'ReturnType #N'
    if (newKeyStringLiteral == null) {
      final typeName = useInfo.returnTypeName;

      int n = 2;
      do {
        final literal = '${typeName} #$n';
        final proposedKey = useInfo.key.copyWithStringLiteralKey(literal);
        if (!effectiveSeenUseKeys.contains(proposedKey)) {
          newKeyStringLiteral = literal;
          break;
        }
        n++;
      } while (n < 30);
    }

    /// --- End of trying to find a new key source code ---

    if (newKeyStringLiteral == null) {
      // Could not determine a unique key.
      return;
    }

    // Find the existing key argument AST expression
    Expression? existingKeyExpr;
    if (useInfo.key.key != null) {
      final keyArg =
          invocationNode.argumentList.arguments
              .where(
                (arg) => arg is NamedExpression && arg.name.label.name == 'key',
              )
              .firstOrNull;
      if (keyArg != null) {
        existingKeyExpr = keyArg;
      }
    }

    // 3. Build and apply the change
    final changeBuilder = reporter.createChangeBuilder(
      message:
          existingKeyExpr != null
              ? 'Update key to be unique'
              : 'Add unique key parameter',
      priority: 30,
    );

    changeBuilder.addDartFileEdit((fileEditBuilder) {
      final newKeyArgumentSource = "key: '$newKeyStringLiteral'";
      if (existingKeyExpr != null) {
        // Replace existing key's value expression
        fileEditBuilder.addSimpleReplacement(
          SourceRange(existingKeyExpr.offset, existingKeyExpr.length),
          newKeyArgumentSource,
        );
      } else {
        // Add new key argument
        final arguments = invocationNode.argumentList.arguments;
        final insertOffset =
            invocationNode.argumentList.rightParenthesis.offset;
        String textToInsert;

        if (arguments.isEmpty) {
          textToInsert = newKeyArgumentSource;
        } else {
          final argListSource = invocationNode.argumentList.toSource();
          String contentBetweenParens = "";
          if (argListSource.length > 2) {
            contentBetweenParens =
                argListSource
                    .substring(1, argListSource.length - 1)
                    .trimRight();
          }

          if (contentBetweenParens.endsWith(',')) {
            textToInsert = " $newKeyArgumentSource";
          } else {
            // Handles both no-comma and empty-but-has-whitespace cases correctly
            textToInsert =
                "${contentBetweenParens.isEmpty ? '' : ', '}$newKeyArgumentSource";
          }
        }
        fileEditBuilder.addSimpleInsertion(insertOffset, textToInsert);
      }
    });
  }
}

// Helper visitor to find the InvocationExpression at the exact error offset and length
class _InvocationExpressionFinder extends GeneralizingAstVisitor<void> {
  _InvocationExpressionFinder(this.targetOffset, this.targetLength);

  final int targetOffset;
  final int targetLength;
  InvocationExpression? foundNode;

  @override
  void visitInvocationExpression(InvocationExpression node) {
    if (node.offset == targetOffset && node.length == targetLength) {
      foundNode = node;
      // Once found, we don't need to look further within this node's children for other InvocationExpressions
      // nor do we need to continue processing other nodes if this is the specific one we seek.
      // However, GeneralizingAstVisitor doesn't have a simple stop mechanism for the whole visit.
      // So, we just capture the node. Further calls to visitInvocationExpression for other nodes are fine.
    }
    // Allow visit to continue to children, in case the target is nested deeper,
    // or to visit other parts of the tree if the first InvocationExpression wasn't the target.
    // GeneralizingAstVisitor handles calling visitNode on children by default after this method.
    super.visitInvocationExpression(node);
  }
}
