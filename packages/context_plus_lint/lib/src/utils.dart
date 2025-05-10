import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/src/dart/ast/utilities.dart' show NodeLocator;
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Adds a visitor for `context(() => ...)` and `context.use(() => ...)` invocations within a build method.
void addContextUseInvocationVisitor(
  LintRuleNodeRegistry registry,
  void Function(ContextUseInfo useInfo) visitor,
) {
  // detect `context(() => ...)` invocations
  registry.addFunctionExpressionInvocation((node) {
    final useInfo = ContextUseInfo.fromInvocation(node);
    if (useInfo != null) {
      visitor(useInfo);
    }
  });

  // detect `context.use(() => ...)` and `context.call(() => ...)` invocations
  registry.addMethodInvocation((node) {
    final useInfo = ContextUseInfo.fromInvocation(node);
    if (useInfo != null) {
      visitor(useInfo);
    }
  });
}

/// Adds a visitor for methods, functions, or function expressions
/// that take BuildContext as a first parameter and return a Widget.
void addBuildMethodVisitor(
  LintRuleNodeRegistry registry,
  void Function(MethodDeclaration node) visitor,
) {
  void checkAndVisit(MethodDeclaration node, ExecutableElement? element) {
    if (element == null) return;

    // Check if the method name is "build"
    if (node.name.lexeme != 'build') {
      return;
    }

    // Check if the first parameter is BuildContext
    if (element.parameters.isEmpty ||
        !isBuildContext(element.parameters[0].type)) {
      return;
    }

    // Check if the return type is Widget
    if (!isWidget(element.returnType)) {
      return;
    }

    // Check if the enclosing class is a Widget or State
    final classDeclaration = node.parent;
    if (classDeclaration is! ClassDeclaration) {
      return;
    }
    final classElement = classDeclaration.declaredElement;
    if (classElement == null) {
      return;
    }
    final classType = classElement.thisType;
    if (!isWidget(classType) && !isState(classType)) {
      return;
    }

    visitor(node);
  }

  registry.addMethodDeclaration((node) {
    checkAndVisit(node, node.declaredElement);
  });
}

/// Returns true if the type is a `BuildContext`.
bool isBuildContext(DartType? type) =>
    type != null &&
    const TypeChecker.fromName(
      'BuildContext',
      packageName: 'flutter',
    ).isAssignableFromType(type);

bool isWidget(DartType? type) =>
    type != null &&
    const TypeChecker.fromName(
      'Widget',
      packageName: 'flutter',
    ).isAssignableFromType(type);

bool isState(DartType? type) =>
    type != null &&
    const TypeChecker.fromName(
      'State',
      packageName: 'flutter',
    ).isAssignableFromType(type);

bool isRef(DartType? type) =>
    type != null &&
    const TypeChecker.fromName(
      'Ref',
      packageName: 'context_ref',
    ).isAssignableFromType(type);

// Helper visitor to find all relevant context.use-like invocations in a FunctionBody:
class RecursiveContextUseInvocationsVisitor extends RecursiveAstVisitor<void> {
  RecursiveContextUseInvocationsVisitor(this.visitor);

  final void Function(ContextUseInfo useInfo) visitor;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final useInfo = ContextUseInfo.fromInvocation(node);
    if (useInfo != null) {
      visitor(useInfo);
    }
    super.visitMethodInvocation(node); // Continue visiting children
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    final useInfo = ContextUseInfo.fromInvocation(node);
    if (useInfo != null) {
      visitor(useInfo);
    }
    super.visitFunctionExpressionInvocation(node); // Continue visiting children
  }
}

class RecursiveInvocationExpressionVisitor extends RecursiveAstVisitor<void> {
  RecursiveInvocationExpressionVisitor(this.visitor);

  final void Function(InvocationExpression node) visitor;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    visitor(node);
    super.visitMethodInvocation(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    visitor(node);
    super.visitFunctionExpressionInvocation(node);
  }
}

VariableDeclaration? findTopLeveleOrStaticVariableDeclaration(
  CompilationUnit unit,
  SimpleIdentifier variableIdentifier,
) {
  // Get the element that the identifier is referring to
  final targetElement = variableIdentifier.staticElement;
  if (targetElement == null) return null;

  final variableName = variableIdentifier.name;

  // First priority: check static fields in class context
  final classNode = variableIdentifier.thisOrAncestorOfType<ClassDeclaration>();
  if (classNode != null) {
    // We're inside a class, so first check static fields in this class
    final className = classNode.name.lexeme;

    // Look for static fields in all classes, prioritizing the current class
    for (final declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        final isCurrentClass = declaration.name.lexeme == className;

        for (final member in declaration.members) {
          if (member is FieldDeclaration && member.isStatic) {
            for (final field in member.fields.variables) {
              if (field.name.lexeme == variableName) {
                // If we're in the same class or we have confirmed the element matches
                if (isCurrentClass || field.declaredElement == targetElement) {
                  return field;
                }
              }
            }
          }
        }
      }
    }
  }

  // Second priority: check top-level variables
  for (final declaration in unit.declarations) {
    if (declaration is TopLevelVariableDeclaration) {
      for (final variable in declaration.variables.variables) {
        if (variable.name.lexeme == variableName) {
          return variable;
        }
      }
    }
  }

  // Third priority: check other static fields (if not found in current class)
  for (final declaration in unit.declarations) {
    if (declaration is ClassDeclaration) {
      for (final member in declaration.members) {
        if (member is FieldDeclaration && member.isStatic) {
          for (final field in member.fields.variables) {
            if (field.name.lexeme == variableName) {
              return field;
            }
          }
        }
      }
    }
  }

  return null;
}

T? findErrorNode<T extends AstNode>(CompilationUnit unit, AnalysisError error) {
  final node = NodeLocator(error.offset).searchWithin(unit);
  if (node == null) {
    print('findErrorNode<$T>() == null');
    return null;
  }

  return node.thisOrAncestorOfType<T>();
}

extension type RefBindExpression(MethodInvocation node) {
  static RefBindExpression? fromInvocation(InvocationExpression? node) {
    if (node == null) {
      return null;
    }

    if (node is! MethodInvocation) {
      return null;
    }

    final name = node.methodName.name;
    if (name != 'bind' && name != 'bindLazy' && name != 'bindValue') {
      return null;
    }
    final targetType = node.target?.staticType;
    if (!isRef(targetType)) {
      return null;
    }
    return RefBindExpression(node);
  }

  Expression get ref => node.target!;
  Identifier? get refIdentifier => ref.thisOrAncestorOfType<Identifier>();
  String? get assignedVariableName =>
      node.parent is VariableDeclaration
          ? (node.parent as VariableDeclaration).name.lexeme
          : null;
  DartType? get returnType => node.staticType;

  void replaceRefTarget({
    required DartFileEditBuilder builder,
    required String refName,
  }) {
    builder.addSimpleReplacement(ref.sourceRange, refName);
  }
}

class ContextUseInfo {
  const ContextUseInfo._({
    required this.node,
    required this.key,
    required this.assignedVariableName,
  });

  static ContextUseInfo? fromInvocation(InvocationExpression node) {
    if (!_isContextUseExpression(node)) {
      return null;
    }

    final contextUseKey = ContextUseKey.fromInvocation(node);
    if (contextUseKey == null) {
      return null;
    }

    final assignedVariableName =
        node.parent is VariableDeclaration
            ? (node.parent as VariableDeclaration).name.lexeme
            : null;

    return ContextUseInfo._(
      node: node,
      key: contextUseKey,
      assignedVariableName: assignedVariableName,
    );
  }

  final InvocationExpression node;
  final ContextUseKey key;
  final String? assignedVariableName;

  DartType get returnType => key.type;
  String get returnTypeName => key.type.getDisplayString();

  NamedExpression? get refExpression =>
      node.argumentList.arguments
          .whereType<NamedExpression>()
          .where((arg) => arg.name.label.name == 'ref')
          .firstOrNull;

  Identifier? get refIdentifier {
    final refExpr = refExpression?.expression;
    if (refExpr == null) {
      return null;
    }

    return refExpr.thisOrAncestorOfType<Identifier>();
  }

  void addOrReplaceRefArgument({
    required CustomLintResolver resolver,
    required DartFileEditBuilder builder,
    required String refName,
  }) {
    final refExpr = refExpression?.expression;
    if (refExpr != null) {
      builder.addSimpleReplacement(refExpr.sourceRange, refName);
    } else {
      final newRefArgument = 'ref: $refName';

      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) {
        builder.addSimpleInsertion(
          node.argumentList.leftParenthesis.end,
          newRefArgument,
        );
      } else {
        final lastArgument = arguments.last;
        final source = resolver.source.contents.data;
        final endOfLastArg = lastArgument.end;
        bool hasTrailingComma = false;
        if (node.argumentList.rightParenthesis.offset > endOfLastArg) {
          final textBetween = source.substring(
            endOfLastArg,
            node.argumentList.rightParenthesis.offset,
          );
          if (textBetween.trimLeft().startsWith(',')) {
            hasTrailingComma = true;
          }
        }

        if (hasTrailingComma) {
          builder.addSimpleInsertion(
            node.argumentList.rightParenthesis.offset,
            ' $newRefArgument',
          );
        } else {
          builder.addSimpleInsertion(lastArgument.end, ', $newRefArgument');
        }
      }
    }
  }

  @override
  String toString() {
    if (assignedVariableName == null) {
      return 'context.use$key';
    }
    return '$assignedVariableName = context.use$key';
  }

  @override
  bool operator ==(Object other) {
    if (other is! ContextUseInfo) {
      return false;
    }

    return key == other.key &&
        assignedVariableName == other.assignedVariableName;
  }

  @override
  int get hashCode => Object.hash(key, assignedVariableName);

  /// Returns true if the node is a `context.use()`, `context.call()` or `context()` invocation.
  static bool _isContextUseExpression(final InvocationExpression node) {
    switch (node) {
      case MethodInvocation():
        if (node.methodName.name != 'use' && node.methodName.name != 'call' ||
            !isBuildContext(node.target?.staticType)) {
          return false;
        }

        return true;
      case FunctionExpressionInvocation():
        final invokedElement = node.staticElement;
        if (invokedElement is! MethodElement || invokedElement.name != 'call') {
          return false;
        }

        final enclosingElement = invokedElement.enclosingElement3;
        if (enclosingElement is! ExtensionElement ||
            enclosingElement.name != 'ContextUseAPI') {
          return false;
        }

        final extendedType = enclosingElement.extendedType;
        if (!isBuildContext(extendedType)) {
          return false;
        }

        return true;
    }

    return false;
  }
}

class ContextUseKey {
  const ContextUseKey._({
    required this.type,
    required this.refSource,
    required this.key,
    required this.isStringLiteralKey,
  });

  static ContextUseKey? fromInvocation(InvocationExpression? node) {
    if (node == null) {
      return null;
    }

    final returnType = node.staticType;
    if (returnType == null) {
      // This should ideally not happen for nodes that triggered the lint
      return null;
    }

    String? key;
    String? refSource;
    bool isStringLiteralKey = false;

    for (final arg in node.argumentList.arguments) {
      if (arg is NamedExpression) {
        if (arg.name.label.name == 'key') {
          final expr = arg.expression.unParenthesized;
          if (expr is StringLiteral) {
            key = expr.stringValue;
            isStringLiteralKey = true;
          } else {
            key = expr.toSource();
          }
        } else if (arg.name.label.name == 'ref') {
          final expr = arg.expression.unParenthesized;
          refSource = expr.toSource();
        }
      }
    }
    return ContextUseKey._(
      type: returnType,
      refSource: refSource,
      key: key,
      isStringLiteralKey: isStringLiteralKey,
    );
  }

  final DartType type;
  final String? refSource;
  // Actual value between "" or '' if String literal, source otherwise
  final String? key;
  final bool isStringLiteralKey;

  ContextUseKey copyWithStringLiteralKey(String newKey) => ContextUseKey._(
    type: type,
    refSource: refSource,
    key: newKey,
    isStringLiteralKey: true,
  );

  @override
  String toString() => '<$type>(ref: $refSource, key: $key)';

  @override
  bool operator ==(Object other) {
    if (other is! ContextUseKey) {
      return false;
    }

    return type == other.type &&
        refSource == other.refSource &&
        key == other.key &&
        isStringLiteralKey == other.isStringLiteralKey;
  }

  @override
  int get hashCode => Object.hash(type, refSource, key, isStringLiteralKey);
}

String createProposedTopLevelRefName({
  required CompilationUnit unit,
  required DartType? returnType,
  String? assignedVariableName,
  String? originalRefName,
}) {
  bool checkTopLevelVariableNameExistsInFile(String variableName) {
    for (final declaration in unit.declarations) {
      if (declaration is TopLevelVariableDeclaration) {
        for (final variable in declaration.variables.variables) {
          if (variable.name.lexeme == variableName) {
            return true;
          }
        }
      } else if (declaration is FunctionDeclaration) {
        if (declaration.isGetter && declaration.name.lexeme == variableName) {
          return true;
        }
      }
    }
    return false;
  }

  late String refName;
  if (assignedVariableName != null) {
    refName =
        !assignedVariableName.startsWith('_')
            ? '_$assignedVariableName'
            : assignedVariableName;
  } else if (returnType != null) {
    refName =
        '_${convertTypeNameToVariableName(returnType.getDisplayString())}';
  } else {
    refName = '${originalRefName}2';
  }

  if (checkTopLevelVariableNameExistsInFile(refName)) {
    var newRefName = refName;
    int i = 2;
    while (i < 30 && checkTopLevelVariableNameExistsInFile(newRefName)) {
      newRefName = '$refName$i';
      i++;
    }
    refName = newRefName;
  }

  return refName;
}

void createNewTopLevelRefDeclaration({
  required CompilationUnit unit,
  required DartFileEditBuilder builder,
  required String refName,
  required DartType? type,
}) {
  var typeGeneric = '';
  if (type != null) {
    typeGeneric = '<${type.getDisplayString()}>';
  }

  final topLevelRefDeclaration = 'final $refName = Ref$typeGeneric();';

  TopLevelVariableDeclaration? lastRefDeclaration;
  for (final member in unit.declarations) {
    if (member is TopLevelVariableDeclaration) {
      bool isRef = false;
      final varList = member.variables;

      // Check 1: Explicit type annotation
      final explicitType = varList.type;
      if (explicitType is NamedType) {
        if (explicitType.name2.lexeme == 'Ref') {
          isRef = true;
        }
      }

      // Check 2: Initializer, if not found by explicit type
      if (!isRef && varList.variables.isNotEmpty) {
        final firstVar = varList.variables.first;
        final initializer = firstVar.initializer;
        if (initializer is InstanceCreationExpression) {
          final constructorTypeNode = initializer.constructorName.type;
          if (constructorTypeNode.name2.lexeme == 'Ref') {
            isRef = true;
          }
        }
      }

      if (isRef) {
        lastRefDeclaration = member;
      }
    }
  }

  int insertionOffset;
  String leadingNewlines;

  if (lastRefDeclaration != null) {
    // Insert after the last found Ref declaration
    insertionOffset = lastRefDeclaration.end;
    leadingNewlines = '\n'; // Single newline
  } else {
    // No existing Ref declarations found
    final directives = unit.directives;
    if (directives.isNotEmpty) {
      insertionOffset = directives.last.end;
      leadingNewlines = '\n\n'; // Double newline after imports
    } else {
      insertionOffset = 0; // Beginning of the file
      leadingNewlines = '\n\n'; // Double newline at the beginning
    }
  }
  final String contentToInsert = '$leadingNewlines$topLevelRefDeclaration';
  builder.addSimpleInsertion(insertionOffset, contentToInsert);
}

String convertTypeNameToVariableName(String typeName) {
  while (typeName[0] == '_') {
    typeName = typeName.substring(1);
  }
  if (typeName[0] == typeName[0].toUpperCase()) {
    typeName = typeName[0].toLowerCase() + typeName.substring(1);
  }
  return typeName.split('<').first;
}

extension DartTypeExt on DartType {
  bool isAssignableFromType(DartType otherType, {bool deep = true}) {
    final thisType = this;

    final isTypeAssignable = TypeChecker.fromStatic(
      this,
    ).isAssignableFromType(otherType);
    if (!isTypeAssignable) {
      return false;
    }

    // Check that generics are also assignable
    if (deep && thisType is InterfaceType && otherType is InterfaceType) {
      // If the types have different numbers of type arguments, they're not fully compatible
      if (thisType.typeArguments.length != otherType.typeArguments.length) {
        return false;
      }

      // Check each type argument for compatibility
      for (var i = 0; i < thisType.typeArguments.length; i++) {
        if (!thisType.typeArguments[i].isAssignableFromType(
          otherType.typeArguments[i],
        )) {
          return false;
        }
      }
    }

    return true;
  }

  DartType? get genericTypeArgument {
    if (this is! InterfaceType) {
      return null;
    }

    return (this as InterfaceType).typeArguments.firstOrNull;
  }
}
