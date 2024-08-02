import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'watchOnly() makes widget rebuild only when selected value changes',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      final (widget, rebuildsListenable) = _widget((context) {
        valueNotifier.watchOnly(context, (state) => state.value.a);
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
    'watchOnly() can be called multiple times with the same selector',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      final (widget, rebuildsListenable) = _widget((context) {
        valueNotifier.watchOnly(context, (state) => state.value.a);
        valueNotifier.watchOnly(context, (state) => state.value.a);
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
    'watchOnly() calls may appear and disappear from the build method, triggering rebuilds the same way as watch() does',
    (widgetTester) async {
      final valueNotifier = ValueNotifier(_State(a: 0, b: 0));
      var watchA = true;
      var watchB = true;
      final (widget, rebuildsListenable) = _widget((context) {
        if (watchA) {
          valueNotifier.watchOnly(context, (state) => state.value.a);
        }
        if (watchB) {
          valueNotifier.watchOnly(context, (state) => state.value.b);
        }
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);

      // Update only `a`
      (watchA, watchB) = (true, true);
      valueNotifier.value = _State(a: 1, b: 0);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.a)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 2);

      // Update only `b`
      (watchA, watchB) = (true, true);
      valueNotifier.value = _State(a: 1, b: 1);
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchValue(context, (value) => value.b)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 3);

      (watchA, watchB) = (false, true); // Remove selector for `a`
      valueNotifier.value = _State(a: 2, b: 1); // Update only `a` (1)
      await widgetTester.pumpAndSettle();
      // Rebuild is triggered because value selectors did_not change during
      // the previous build and their selected values got updated
      // from (a: 1, b: 1) to (b: 1).
      expect(rebuildsListenable.value, 4);

      (watchA, watchB) = (false, true);
      valueNotifier.value = _State(a: 3, b: 1); // Update only `a` (2)
      await widgetTester.pumpAndSettle();
      // Rebuild is_not triggered because value selector for `a` disappeared
      // during the previous build.
      expect(rebuildsListenable.value, 4);

      (watchA, watchB) = (false, true);
      valueNotifier.value = _State(a: 4, b: 1); // Update only `a` (3)
      await widgetTester.pumpAndSettle();
      // No rebuild since value selectors did not change during the previous
      // build and their selected values did not change either.
      expect(rebuildsListenable.value, 4);

      (watchA, watchB) = (false, false); // Remove selector for `b`
      valueNotifier.value = _State(a: 3, b: 2); // Update only `b` (1)
      await widgetTester.pumpAndSettle();
      // `valueNotifier.watchOnly(context, (state) => state.value.b)` was present
      // during the previous build, so the rebuild is triggered
      expect(rebuildsListenable.value, 5);

      (watchA, watchB) = (false, false);
      valueNotifier.value = _State(a: 3, b: 3); // Update only `b` (2)
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 5); // No rebuild

      (watchA, watchB) = (false, false);
      valueNotifier.value = _State(a: 3, b: 4); // Update only `b` (3)
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 5); // No rebuild

      (watchA, watchB) = (false, false);
      valueNotifier.value = _State(a: 4, b: 5); // Update both `a` and `b`
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 5); // No rebuild
    },
  );
  testWidgets(
    '.watchOnly() calls are_not unsubscribed when selected value does_not change',
    (tester) async {
      var rebuilds = 0;
      var selectedValue = '';
      final notifier = ChangeNotifier();

      await tester.pumpWidget(
        ContextWatch.root(
          child: Builder(
            builder: (context) {
              rebuilds++;
              notifier.watchOnly(context, (_) => selectedValue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(rebuilds, 1);

      selectedValue = 'a';
      notifier.notifyListeners();
      await tester.pumpAndSettle();
      notifier.notifyListeners();
      await tester.pumpAndSettle();
      notifier.notifyListeners();
      await tester.pumpAndSettle();
      // 3 notification, only one rebuild since selected value didn't change
      expect(rebuilds, 2);

      selectedValue = 'b';
      notifier.notifyListeners();
      await tester.pumpAndSettle();
      // selected value changed, so rebuild happens, even though previous rebuilds were skipped
      expect(rebuilds, 3);
    },
  );
  testWidgets(
    'Listenable.watchOnly() rebuilds the widget only when the selected value changes',
    (widgetTester) async {
      final state = _StateChangeNotifier();
      final (widget, rebuildsListenable) = _widget((context) {
        state.watchOnly(context, (state) => state.counter1);
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
    'Listenable.watch() and Listenable.watchOnly() can be used together',
    (widgetTester) async {
      final state = _StateChangeNotifier();

      final useWatch = ValueNotifier(true);
      final useWatchOnly = ValueNotifier(true);
      final (widget, rebuildsListenable) = _widget((context) {
        if (useWatch.watch(context)) {
          state.watch(context);
        }
        if (useWatchOnly.watch(context)) {
          state.watchOnly(context, (state) => state.counter1);
        }
        return const SizedBox.shrink();
      });

      await widgetTester.pumpWidget(widget);
      expect(rebuildsListenable.value, 1);

      // state.counter2 should trigger the rebuild because it's watched
      // with state.watch()
      state.counter2 = 1;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 2);

      // state.counter1 should trigger the rebuild because it's watched
      // with state.watchOnly()
      state.counter1 = 1;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 3);

      // remove state.watchOnly()
      useWatchOnly.value = false;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 4);

      // state.counter1 should still trigger the rebuild because it's watched
      // with state.watch()
      state.counter1 = 2;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 5);
      state.counter1 = 3;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 6);

      // state.counter2 should still trigger the rebuild because it's watched
      // with state.watch()
      state.counter2 = 2;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 7);

      // remove state.watch()
      useWatch.value = false;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 8);

      // state.counter1 or state.counter2 should not trigger the rebuild because
      // there are no more watches
      state.counter1 = 4;
      state.counter2 = 3;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 8);

      // add watching back
      useWatch.value = true;
      useWatchOnly.value = true;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 9);

      // state.counter1 should trigger the rebuild because it's watched
      // with state.watchOnly()
      state.counter1 = 5;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 10);

      // state.counter2 should trigger the rebuild because it's watched
      // with state.watch()
      state.counter2 = 4;
      await widgetTester.pumpAndSettle();
      expect(rebuildsListenable.value, 11);
    },
  );
  testWidgets(
    'Stream.watchOnly() gives the AsyncSnapshot as a value for selector',
    (widgetTester) async {
      final observedData = <int?>[];

      final streamController = StreamController<int>();
      final stream = streamController.stream;
      final (widget, rebuildsListenable) = _widget((context) {
        final data = stream.watchOnly(context, (snapshot) => snapshot.data);
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
    'Future.watchOnly() gives the AsyncSnapshot as a value for selector',
    (widgetTester) async {
      final observedData = <int?>[];

      final completer = Completer<int>();
      final future = completer.future;
      final (widget, rebuildsListenable) = _widget((context) {
        final data = future.watchOnly(context, (snapshot) => snapshot.data);
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
