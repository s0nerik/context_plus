import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'watchValue() makes widget rebuild only when selected value changes',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      final (widget, rebuildsListenable) = _widget((context) {
        valueNotifier.watchValueQuery(context, (value) => value.a);
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
  testWidgets(
    'watchValue() can be called multiple times with the same selector',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      final (widget, rebuildsListenable) = _widget((context) {
        valueNotifier.watchValueQuery(context, (value) => value.a);
        valueNotifier.watchValueQuery(context, (value) => value.a);
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
  testWidgets(
    'watchValue() calls may appear and disappear from the build method, triggering rebuilds the same way as watch() does',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      var unwatch = false;
      var watchA = true;
      var watchB = true;
      final (widget, rebuildsListenable) = _widget((context) {
        if (unwatch) {
          context.unwatch();
        }
        if (watchA) {
          valueNotifier.watchValueQuery(context, (value) => value.a);
        }
        if (watchB) {
          valueNotifier.watchValueQuery(context, (value) => value.b);
        }
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);

      // Update only `a`
      valueNotifier.value = _State(a: 1, b: 0);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.a)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 2);

      // Update only `b`
      valueNotifier.value = _State(a: 1, b: 1);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.b)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 3);

      // Remove `valueNotifier.watchValue(context, (value) => value.a)` from
      // the build method and update only `a`
      watchA = false;
      valueNotifier.value = _State(a: 2, b: 1);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.a)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 4);

      // Update only `a`
      valueNotifier.value = _State(a: 3, b: 1);
      await widgetTester.pumpAndSettle();
      // No rebuild since `valueNotifier.watchValue(context, (value) => value.a)`
      // was not present during the previous build
      expect(rebuildsListenable.value, 4);

      // Remove `valueNotifier.watchValue(context, (value) => value.b)` from
      // the build method and update only `b`
      watchB = false;
      valueNotifier.value = _State(a: 3, b: 2);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.b)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 5);

      // Update only `b`
      valueNotifier.value = _State(a: 3, b: 3);
      await widgetTester.pumpAndSettle();
      // Even though `valueNotifier.watchValue(context, (value) => value.b)` was
      // not present during the previous build, the rebuild is triggered because
      // it was the last `watch*()` call that got removed. Unfortunately,
      // it's impossible for [context_watch] to detect this automatically.
      //
      // This usually is not a problem, and in fact matches the behavior of
      // any [InheritedWidget] subscription. If you want to avoid this behavior
      // in a specific case, you can add an unconditional `context.unwatch()`
      // call in your build method.
      expect(rebuildsListenable.value, 6);

      // Add `context.unwatch()` to the build method and update only `b`
      unwatch = true;
      valueNotifier.value = _State(a: 3, b: 4);
      await widgetTester.pumpAndSettle();
      // Rebuild is triggered because `context.unwatch()` was not called during
      // the previous build, while `valueNotifier.watchValue(context, (value) => value.b)`
      // removal was not yet detected.
      expect(rebuildsListenable.value, 7);

      valueNotifier.value = _State(a: 4, b: 5);
      await widgetTester.pumpAndSettle();
      // No rebuild since `context.unwatch()` was called during the previous
      // build while no `watch*()` calls happened.
      expect(rebuildsListenable.value, 7);
    },
  );
  testWidgets(
    'Listenable.watchListenableValue() rebuilds the widget only when the selected value changes',
    (widgetTester) async {
      final state = _StateChangeNotifier();
      final (widget, rebuildsListenable) = _widget((context) {
        state.watchQuery(context, (state) => state.counter1);
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);

      // Changing the initial value should trigger a rebuild
      state.counter1 = 1;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      // Adding the same value again should not trigger a rebuild
      state.counter1 = 1;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      // Changing the value should trigger a rebuild
      state.counter1 = 2;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 3);

      // Changing another value should not trigger a rebuild
      state.counter2 = 1;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 3);
    },
  );
  testWidgets(
    'Stream.watchValue() gives the AsyncSnapshot as a value for selector',
    (widgetTester) async {
      final observedData = <int?>[];

      final streamController = StreamController<int>();
      final stream = streamController.stream;
      final (widget, rebuildsListenable) = _widget((context) {
        final data = stream.watchValue(context, (snapshot) => snapshot.data);
        observedData.add(data);
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);
      expect(observedData, [null]);

      streamController.add(1);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);
      expect(observedData, [null, 1]);

      // Adding the same value again should not trigger a rebuild
      streamController.add(1);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);
    },
  );
  testWidgets(
    'Future.watchValue() gives the AsyncSnapshot as a value for selector',
    (widgetTester) async {
      final observedData = <int?>[];

      final completer = Completer<int>();
      final future = completer.future;
      final (widget, rebuildsListenable) = _widget((context) {
        final data = future.watchValue(context, (snapshot) => snapshot.data);
        observedData.add(data);
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);
      expect(observedData, [null]);

      completer.complete(1);
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);
      expect(observedData, [null, 1]);
    },
  );
}

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

class _StateChangeNotifier with ChangeNotifier {
  int _counter1 = 0;
  int get counter1 => _counter1;
  set counter1(int value) {
    _counter1 = value;
    notifyListeners();
  }

  int _counter2 = 0;
  int get counter2 => _counter2;
  set counter2(int value) {
    _counter2 = value;
    notifyListeners();
  }
}
