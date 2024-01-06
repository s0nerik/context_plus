import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

(Widget, ValueListenable<int>) _widget(WidgetBuilder builder) {
  final rebuildsNotifier = ValueNotifier(0);
  return (
    ContextWatch.root(
      child: Builder(
        builder: (context) {
          rebuildsNotifier.value++;
          return builder(context);
        },
      ),
    ),
    rebuildsNotifier,
  );
}

class _State {
  final int a;
  final int b;

  _State({
    required this.a,
    required this.b,
  });
}

void main() {
  testWidgets(
    'watchFor() makes widget rebuild only when selected value changes',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      final (widget, rebuildsListenable) = _widget((context) {
        valueNotifier.watchFor(context, (value) => value.a);
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);

      valueNotifier.value = _State(a: 1, b: 0);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      valueNotifier.value = _State(a: 1, b: 1);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      valueNotifier.value = _State(a: 1, b: 2);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      valueNotifier.value = _State(a: 2, b: 2);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 3);
    },
  );
}
