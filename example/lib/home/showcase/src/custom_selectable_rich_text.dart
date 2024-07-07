import 'package:context_plus/context_plus.dart';
import 'package:example/home/showcase/src/copyable_widget_span.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _focusNode = Ref<FocusNode>();
final _textSelection = Ref<ValueNotifier<TextSelection?>>();
final _pressedKeys = Ref<ValueNotifier<Set<LogicalKeyboardKey>>>();

class CustomSelectableRichText extends StatelessWidget {
  const CustomSelectableRichText(
    this.span, {
    super.key,
  });

  final TextSpan span;
  void _handleKey(BuildContext context, KeyEvent event) {
    final oldPressedKeys = _pressedKeys.of(context).value;
    final pressedKeys = {...oldPressedKeys};
    if (event is KeyDownEvent) {
      pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      pressedKeys.remove(event.logicalKey);
    }
    _pressedKeys.of(context).value = pressedKeys;

    final copyRequested =
        (oldPressedKeys.contains(LogicalKeyboardKey.metaLeft) ||
                oldPressedKeys.contains(LogicalKeyboardKey.metaRight)) &&
            oldPressedKeys.contains(LogicalKeyboardKey.keyC);
    final copyConfirmed = pressedKeys.contains(LogicalKeyboardKey.metaLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.metaRight) ||
        pressedKeys.contains(LogicalKeyboardKey.keyC);

    if (copyRequested && copyConfirmed) {
      _copyToClipboard(context, span, _textSelection.of(context).value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = _focusNode.bind(context, () => FocusNode());
    final textSelection =
        _textSelection.bind(context, () => ValueNotifier(null));
    _pressedKeys.bind(context, () => ValueNotifier(const {}));
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
