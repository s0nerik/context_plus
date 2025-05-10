import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:context_plus_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// Assuming Ref is from 'package:context_plus/context_plus.dart'
const _refChecker = TypeChecker.fromName('Ref', packageName: 'context_ref');

class WrongRefDeclarationLint extends DartLintRule {
  const WrongRefDeclarationLint() : super(code: _code);

  static const _code = LintCode(
    name: 'wrong_ref_declaration',
    problemMessage:
        'Ref instances must be declared as top-level final variables or static final fields.',
    correctionMessage:
        'Declare this Ref as a top-level final variable (e.g. final myRef = Ref();) or as a static final field within a class/extension (e.g. static final myRef = Ref();).',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclarationList((node) {
      for (final variable in node.variables) {
        final element = variable.declaredElement;
        if (element == null) {
          continue;
        }

        // Check if the variable's type is Ref
        if (!_refChecker.isAssignableFromType(element.type)) {
          continue;
        }

        AstNode? declarationNode = variable.parent; // VariableDeclarationList
        if (declarationNode == null) continue;

        AstNode? contextNode =
            declarationNode
                .parent; // TopLevelVariableDeclaration, FieldDeclaration, VariableDeclarationStatement
        if (contextNode == null) continue;

        bool isAllowed = false;

        if (contextNode is TopLevelVariableDeclaration) {
          isAllowed = node.isFinal;
        } else if (contextNode is FieldDeclaration) {
          isAllowed = contextNode.isStatic && node.isFinal;
        } else if (contextNode is VariableDeclarationStatement) {
          // Covers local variables in functions, methods, if statements, loops etc.
          isAllowed = false;
        }
        // What about FormalParameterList?
        // For now, sticking to the explicit request: "variable in the method or a class field"

        if (!isAllowed) {
          reporter.atOffset(
            offset: variable.name.offset,
            length: variable.name.length,
            errorCode: _code,
          );
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_ConvertToTopLevelRef()];
}

class _ConvertToTopLevelRef extends DartFix {
  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError error,
    List<AnalysisError> resolvedErrors,
  ) async {
    final resolvedUnitResult = await resolver.getResolvedUnitResult();
    if (!resolvedUnitResult.exists) return;
    final unit = resolvedUnitResult.unit;

    final variableDeclaration = findErrorNode<VariableDeclaration>(unit, error);
    if (variableDeclaration == null) {
      return;
    }

    final variableName = variableDeclaration.name.lexeme;
    final newVariableName =
        '${variableName.startsWith("_") ? "" : "_"}${variableName}${variableName.toLowerCase().endsWith("ref") ? "" : "Ref"}';

    _convertToTopLevelRef(
      variableDeclaration,
      newVariableName,
      reporter.createChangeBuilder(
        message: 'Convert to top-level private Ref',
        priority: 80,
      ),
    );
  }

  void _convertToTopLevelRef(
    VariableDeclaration variableDeclaration,
    String newVariableName,
    ChangeBuilder changeBuilder,
  ) {
    changeBuilder.addDartFileEdit((builder) {
      final variableDeclarationList = variableDeclaration.parent;
      if (variableDeclarationList is! VariableDeclarationList) {
        return;
      }

      final statementToDelete = variableDeclarationList.parent;
      if (!(statementToDelete is VariableDeclarationStatement ||
          statementToDelete is FieldDeclaration ||
          statementToDelete is TopLevelVariableDeclaration)) {
        return; // Unrecognized structure to delete
      }

      // Delete the original declaration
      builder.addDeletion(statementToDelete!.sourceRange);

      final initializer = variableDeclaration.initializer;
      String topLevelDeclaration;
      if (initializer != null) {
        topLevelDeclaration =
            'final $newVariableName = ${initializer.toSource()};';
      } else {
        final type = variableDeclaration.declaredElement?.type;
        if (type == null) {
          print('type == null');
          return;
        }
        topLevelDeclaration = 'final $newVariableName = $type();';
      }

      // Find insertion point - first check for existing Ref declarations
      final root = variableDeclaration.root as CompilationUnit;
      TopLevelVariableDeclaration? lastRefDeclaration;

      for (final declaration in root.declarations) {
        if (declaration is TopLevelVariableDeclaration) {
          for (final variable in declaration.variables.variables) {
            if (variable.declaredElement?.type != null &&
                _refChecker.isAssignableFromType(
                  variable.declaredElement!.type,
                )) {
              lastRefDeclaration = declaration;
              // Don't break here - we want the last one
            }
          }
        }
      }

      if (lastRefDeclaration != null) {
        // Insert after the last Ref declaration
        builder.addSimpleInsertion(
          lastRefDeclaration.end,
          '\n$topLevelDeclaration',
        );
      } else {
        // No existing Ref declarations found, add after imports
        int insertAfterImports = 0;

        // Find position after last import directive
        for (final directive in root.directives) {
          if (directive.end > insertAfterImports) {
            insertAfterImports = directive.end;
          }
        }

        // If there are imports, add a blank line after them
        final prefix = insertAfterImports > 0 ? '\n\n' : '';

        builder.addSimpleInsertion(
          insertAfterImports,
          '$prefix$topLevelDeclaration',
        );
      }
    });
  }
}
