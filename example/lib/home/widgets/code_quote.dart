import 'package:flutter/material.dart';

const _codeBackground = Color(0xFF1D1E21);
const _borderColor = Colors.white12;
const _typeColor = Color(0xFF84D6EB);
const _functionColor = Color(0xFFB2DF52);
const _fontFamily = 'Fira Code';

abstract final class CodeQuote {
  static Widget type(
    String typeName, {
    TextStyle? style,
  }) =>
      _CodeType(typeName: typeName, style: style);

  static Widget functionCall(
    String functionName, {
    TextStyle? style,
  }) =>
      _FunctionCall(functionName: functionName, style: style);
}

class _CodeType extends StatelessWidget {
  const _CodeType({
    required this.typeName,
    required this.style,
  });

  final String typeName;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return _CodeQuote(
      child: Text(
        typeName,
        style: style != null
            ? style!
                .copyWith(fontFamily: _fontFamily, color: _typeColor, height: 1)
            : const TextStyle(
                fontFamily: _fontFamily, color: _typeColor, height: 1),
      ),
    );
  }
}

class _FunctionCall extends StatelessWidget {
  const _FunctionCall({
    required this.functionName,
    required this.style,
  });

  final String functionName;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return _CodeQuote(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '.',
            style: style != null
                ? style!.copyWith(fontFamily: _fontFamily, height: 1)
                : const TextStyle(fontFamily: _fontFamily, height: 1),
          ),
          Text(
            functionName,
            style: style != null
                ? style!.copyWith(
                    fontFamily: _fontFamily, color: _functionColor, height: 1)
                : const TextStyle(
                    fontFamily: _fontFamily, color: _functionColor, height: 1),
          ),
          Text(
            '()',
            style: style != null
                ? style!.copyWith(fontFamily: _fontFamily, height: 1)
                : const TextStyle(fontFamily: _fontFamily, height: 1),
          ),
        ],
      ),
    );
  }
}

class _CodeQuote extends StatelessWidget {
  const _CodeQuote({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 2),
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: _codeBackground,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _borderColor),
        ),
        child: child,
      ),
    );
  }
}
