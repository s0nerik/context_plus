import 'package:context_plus/context_plus.dart';
import 'package:example/home/showcase/src/copyable_widget_span.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _focusNode = Ref<FocusNode>();
final _textSelection = Ref<ValueNotifier<TextSelection?>>();
final _isMetaPressed = Ref<ValueNotifier<bool>>();

class CustomSelectableRichText extends StatelessWidget {
  const CustomSelectableRichText(
    this.span, {
    super.key,
  });

  final TextSpan span;

  static bool _updateIsMetaPressed(BuildContext context, KeyEvent event) {
    if (event is KeyDownEvent &&
            event.physicalKey == PhysicalKeyboardKey.metaLeft ||
        event.physicalKey == PhysicalKeyboardKey.metaRight) {
      _isMetaPressed.of(context).value = true;
    }
    if (event is KeyUpEvent &&
            event.physicalKey == PhysicalKeyboardKey.metaLeft ||
        event.physicalKey == PhysicalKeyboardKey.metaRight) {
      _isMetaPressed.of(context).value = false;
    }
    return _isMetaPressed.of(context).value;
  }

  void _handleKey(BuildContext context, KeyEvent event) {
    final isMetaPressed = _updateIsMetaPressed(context, event);

    if (isMetaPressed &&
        event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.keyC) {
      _copyToClipboard(context, span, _textSelection.of(context).value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = _focusNode.bind(context, () => FocusNode());
    final textSelection =
        _textSelection.bind(context, () => ValueNotifier(null));
    _isMetaPressed.bind(context, () => ValueNotifier(false));
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) => _handleKey(context, event),
      child: Focus(
        autofocus: true,
        child: SelectableText.rich(
          span,
          onSelectionChanged: (selection, source) =>
              textSelection.value = selection,
          contextMenuBuilder: (context, editableTextState) {
            final buttonItems = editableTextState.contextMenuButtonItems;
            final copyButtonIndex = buttonItems
                .indexWhere((btn) => btn.type == ContextMenuButtonType.copy);
            if (copyButtonIndex >= 0) {
              final copyButtonItem = buttonItems[copyButtonIndex];
              buttonItems[copyButtonIndex] = copyButtonItem.copyWith(
                onPressed: () {
                  _copyToClipboard(context, span, textSelection.value);
                  editableTextState.bringIntoView(
                    editableTextState.textEditingValue.selection.extent,
                  );
                  editableTextState.hideToolbar(false);
                  editableTextState.clipboardStatus.update();
                },
              );
            }
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems: buttonItems,
            );
          },
        ),
      ),
    );
  }
}

void _copyToClipboard(
  BuildContext context,
  TextSpan span,
  TextSelection? selection,
) {
  final copyableSpans =
      span.children?.whereType<CopyableWidgetSpan>().toList() ?? const [];
  final plainText = span.toPlainText();
  final selectedText = selection?.textInside(plainText) ?? plainText;

  var copyContent = selectedText;
  for (final copyableSpan in copyableSpans) {
    copyContent = copyContent.replaceFirst(
      CopyableWidgetSpan.replacementChars[copyableSpan.index],
      copyableSpan.plainText,
    );
  }
  Clipboard.setData(ClipboardData(text: copyContent));

  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Copied to clipboard!'),
  ));
}
