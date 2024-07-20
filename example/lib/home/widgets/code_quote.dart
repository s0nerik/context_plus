import 'package:context_plus/context_plus.dart';
import 'package:example/home/widgets/dynamic_section_text.dart';
import 'package:example/other/code_highlighter_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

const _codeFilenameBackground = Color(0xFF2F2F33);
const _codeBackground = Color(0xFF1D1E21);
const _borderColor = Colors.white12;

const _typeColor = Color(0xFF84D6EB);
const _typeColorVsCode = Color(0xFF4EC9B0);

const _functionColor = Color(0xFFB2DF52);
const _functionColorVsCode = Color(0xFFDCDCAA);

const _parameterColor = Color(0xFFFF9B2B);

const _otherCodeColor = Colors.white;
const _fontFamily = 'Fira Code';

enum CodeStyle {
  gapStyle, // default, used in the showcase
  vsCode, // used in the code snippets
}

class CodeQuote extends StatelessWidget {
  const CodeQuote({
    super.key,
    this.margin = EdgeInsets.zero,
    required this.child,
    this.bottomOffset = 2,
  });

  final EdgeInsets margin;
  final Widget child;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontFamily: _fontFamily,
        color: _otherCodeColor,
        height: 1,
      ),
      child: Transform.translate(
        offset: Offset(0, bottomOffset),
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

class CodeMultilineQuote extends StatelessWidget {
  const CodeMultilineQuote({
    super.key,
    required this.fileName,
    required this.code,
    this.copyableCode,
  });

  final String fileName;
  final String code;
  final String? copyableCode;

  static final _codeScrollController = Ref<ScrollController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: _codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilenameHeader(context),
          _buildCodeArea(context),
        ],
      ),
    );
  }

  Widget _buildFilenameHeader(BuildContext context) {
    return Container(
      height: 28,
      decoration: const BoxDecoration(
        color: _codeFilenameBackground,
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              fileName,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: _fontFamily,
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: -6,
            child: IconButton(
              icon: const Icon(MdiIcons.contentCopy, size: 16),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: copyableCode ?? code),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeArea(BuildContext context) {
    final darkCodeTheme = darkCodeThemeFuture.watch(context).data;
    if (darkCodeTheme == null) {
      return const SizedBox.shrink();
    }

    final fileExt = fileName.split('.').last;
    final highlighter = switch (fileExt) {
      'yaml' || 'yml' => Highlighter(language: 'yaml', theme: darkCodeTheme),
      'dart' => Highlighter(language: 'dart', theme: darkCodeTheme),
      _ => throw UnsupportedError('Unsupported file extension: $fileExt'),
    };

    final scrollController =
        _codeScrollController.bind(context, ScrollController.new);

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SelectableText.rich(
            highlighter.highlight(code),
            textAlign: TextAlign.left,
            style: const TextStyle(fontFamily: _fontFamily),
          ),
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
    this.style = CodeStyle.gapStyle,
  });

  final String type;
  final List<String> genericTypes;
  final bool animate;
  final CodeStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(
            fontFamily: _fontFamily,
            color: switch (style) {
              CodeStyle.gapStyle => _typeColor,
              CodeStyle.vsCode => _typeColorVsCode,
            },
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
    this.style = CodeStyle.gapStyle,
  });

  final String name;
  final List<Widget> params;
  final bool animate;
  final CodeStyle style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: _fontFamily),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('.'),
          DefaultTextStyle.merge(
            style: TextStyle(
              color: switch (style) {
                CodeStyle.gapStyle => _functionColor,
                CodeStyle.vsCode => _functionColorVsCode,
              },
            ),
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
