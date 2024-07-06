import 'package:flutter/widgets.dart';

class CopyableWidgetSpan extends WidgetSpan {
  const CopyableWidgetSpan({
    required super.child,
    required this.index,
    required this.plainText,
    super.alignment,
    super.baseline,
    super.style,
  }) : assert(index >= 0 && index <= 50);

  final int index;
  final String plainText;

  // Unicode characters for 0-50 inside a circle, grouped by 10
  static const replacementChars = [
    '⓪', '①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', // 0-9
    '⑩', '⑪', '⑫', '⑬', '⑭', '⑮', '⑯', '⑰', '⑱', '⑲', // 10-19
    '⑳', '㉑', '㉒', '㉓', '㉔', '㉕', '㉖', '㉗', '㉘', '㉙', // 20-29
    '㉚', '㉛', '㉜', '㉝', '㉞', '㉟', '㊱', '㊲', '㊳', '㊴', // 30-39
    '㊵', '㊶', '㊷', '㊸', '㊹', '㊺', '㊻', '㊼', '㊽', '㊾', // 40-49
    '㊿',
  ];

  @override
  String toPlainText({
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    return replacementChars[index];
  }

  @override
  void computeToPlainText(
    StringBuffer buffer, {
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    buffer.write(replacementChars[index]);
  }
}
