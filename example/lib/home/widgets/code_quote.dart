import 'package:example/home/widgets/dynamic_section_text.dart';
import 'package:flutter/material.dart';

const _codeBackground = Color(0xFF1D1E21);
const _borderColor = Colors.white12;
const _typeColor = Color(0xFF84D6EB);
const _functionColor = Color(0xFFB2DF52);
const _parameterColor = Color(0xFFFF9B2B);
const _otherCodeColor = Colors.white;
const _fontFamily = 'Fira Code';

class CodeQuote extends StatelessWidget {
  const CodeQuote({
    super.key,
    this.margin = EdgeInsets.zero,
    required this.child,
  });

  final EdgeInsets margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontFamily: _fontFamily,
        color: _otherCodeColor,
        height: 1,
      ),
      child: Transform.translate(
        offset: const Offset(0, 2),
        child: Container(
          margin: margin,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _codeBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CodeType extends StatelessWidget {
  const CodeType({
    super.key,
    required this.type,
    this.genericTypes = const [],
    this.animate = true,
  });

  final String type;
  final List<String> genericTypes;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle.merge(
          style: const TextStyle(
            fontFamily: _fontFamily,
            color: _typeColor,
          ),
          child: DynamicSectionText(
            type,
            animate: animate,
          ),
        ),
        if (genericTypes.isNotEmpty) ...[
          const Text('<'),
          for (var i = 0; i < genericTypes.length; i++) ...[
            CodeType(
              type: genericTypes[i],
              animate: animate,
            ),
            if (i < genericTypes.length - 1) const Text(', '),
          ],
          const Text('>'),
        ],
      ],
    );
  }
}

class CodeFunctionCall extends StatelessWidget {
  const CodeFunctionCall({
    super.key,
    required this.name,
    this.params = const [],
    this.animate = true,
  });

  final String name;
  final List<Widget> params;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: _fontFamily),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('.'),
          DefaultTextStyle.merge(
            style: const TextStyle(color: _functionColor),
            child: DynamicSectionText(
              name,
              animate: animate,
            ),
          ),
          const Text('('),
          for (var i = 0; i < params.length; i++) ...[
            params[i],
            if (i < params.length - 1) const Text(', '),
          ],
          const Text(')'),
        ],
      ),
    );
  }
}

class CodeParameter extends StatelessWidget {
  const CodeParameter({
    super.key,
    required this.name,
    this.animate = true,
  });

  final String name;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontFamily: _fontFamily,
        color: _parameterColor,
        fontWeight: FontWeight.w600,
      ),
      child: DynamicSectionText(
        name,
        animate: animate,
      ),
    );
  }
}
