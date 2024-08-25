import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "if any of the .watch()'ed observables notifies of a change, the context is rebuilt",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      final results = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, _) = _widget((context) {
        final result = (valueNotifier, changeNotifier, stream).watch(context);
        results.add(result);
      });

      await tester.pumpWidget(widget);
      expect(rebuilds.value, 1);
      expect(results, [
        (0, null, const AsyncSnapshot.waiting()),
      ]);

      valueNotifier.value++;
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);
      expect(results, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      changeNotifier.notifyListeners();
      await tester.pumpAndSettle();
      expect(rebuilds.value, 3);
      expect(results, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      streamController.add(0);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 4);
      expect(results, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      await tester.pumpAndSettle();
      expect(rebuilds.value, 4); // No notification - no rebuild
      expect(results, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);
    },
  );

  testWidgets(
    "if any of the .watchOnly()'d observables notifies of a change, the selector is called to decide whether to rebuild",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      var selectorResult = 0;
      final selectorParamValues = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, triggerRebuild) = _widget((context) {
        (valueNotifier, changeNotifier, stream).watchOnly(
          context,
          (valueNotifier, changeNotifier, snap) {
            selectorParamValues.add((valueNotifier.value, null, snap));
            return selectorResult;
          },
        );
      });

      await tester.pumpWidget(widget);
      expect(rebuilds.value, 1);
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
      ]);

      valueNotifier.value++;
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // selectorResult did not change, so no rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      changeNotifier.notifyListeners();
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // selectorResult did not change, so no rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      streamController.add(0);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // selectorResult did not change, so no rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No notification - no rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      streamController.add(0);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // selectorResult did not change, so no rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // Even though the stream produced the equal value, the selector was
        // still invoked since the stream notified that it is indeed a new value.
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      selectorResult = 1;
      changeNotifier.notifyListeners();
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2); // selectorResult changed, so rebuild
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // ↓ Parameters for the selector that was invoked to decide whether to rebuild
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // ↓ Parameters for the selector that was invoked *during* the rebuild
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      triggerRebuild(() {});
      await tester.pumpAndSettle();
      expect(rebuilds.value, 3); // Rebuild due to setState()
      expect(selectorParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // ↓ Parameters for the selector that was invoked to decide whether to rebuild
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // ↓ Parameters for the selector that was invoked *during* the previous rebuild
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // ↓ Parameters for the selector that was invoked *during* the rebuild
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);
    },
  );

  testWidgets(
      "if any of the .watchEffect()'d observables notifies of a change, the effect is called, without rebuilding the widget",
      (tester) async {
    final valueNotifier = ValueNotifier(0);
    final changeNotifier = ChangeNotifier();
    final streamController = StreamController<int>();
    final stream = streamController.stream;

    final effectParamValues = <(int, void, AsyncSnapshot<int>)>[];
    final (widget, rebuilds, triggerRebuild) = _widget((context) {
      (valueNotifier, changeNotifier, stream).watchEffect(
        context,
        (valueNotifier, changeNotifier, snap) {
          effectParamValues.add((valueNotifier.value, null, snap));
        },
      );
    });

    await tester.pumpWidget(widget);
    expect(effectParamValues, isEmpty);
    expect(rebuilds.value, 1);

    valueNotifier.value = 1;
    expect(effectParamValues, [(1, null, const AsyncSnapshot.waiting())]);
    await tester.pumpAndSettle();
    expect(rebuilds.value, 1); // No rebuild

    changeNotifier.notifyListeners();
    expect(effectParamValues, [
      (1, null, const AsyncSnapshot.waiting()),
      (1, null, const AsyncSnapshot.waiting()),
    ]);
    await tester.pumpAndSettle();
    expect(rebuilds.value, 1); // No rebuild

    streamController.add(0);
    await Future.value(); // Let the stream notify
    expect(effectParamValues, [
      (1, null, const AsyncSnapshot.waiting()),
      (1, null, const AsyncSnapshot.waiting()),
      (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
    ]);
    await tester.pumpAndSettle();
    expect(rebuilds.value, 1); // No rebuild

    triggerRebuild(() {});
    await tester.pumpAndSettle();
    expect(rebuilds.value, 2); // Rebuild
    // No effects are called during rebuild
    expect(effectParamValues, [
      (1, null, const AsyncSnapshot.waiting()),
      (1, null, const AsyncSnapshot.waiting()),
      (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
    ]);
  });

  testWidgets(
    ".watchEffect() on a group of observable allows the same 'once' parameter as the .watchEffect() on a single observable",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      final effectParamValues = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, triggerRebuild) = _widget((context) {
        (valueNotifier, changeNotifier, stream).watchEffect(
          context,
          (valueNotifier, changeNotifier, snap) {
            effectParamValues.add((valueNotifier.value, null, snap));
          },
          once: true,
          key: 'effect',
        );
      });

      await tester.pumpWidget(widget);
      expect(effectParamValues, isEmpty);
      expect(rebuilds.value, 1);

      valueNotifier.value = 1;
      expect(effectParamValues, [(1, null, const AsyncSnapshot.waiting())]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      changeNotifier.notifyListeners();
      // No effect called since the 'once' parameter is true
      expect(effectParamValues, [(1, null, const AsyncSnapshot.waiting())]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      streamController.add(0);
      await Future.value(); // Let the stream notify
      // No effect called since the 'once' parameter is true
      expect(effectParamValues, [(1, null, const AsyncSnapshot.waiting())]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      triggerRebuild(() {});
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2); // Rebuild
      // No effects are called during rebuild
      expect(effectParamValues, [(1, null, const AsyncSnapshot.waiting())]);
    },
  );

  testWidgets(
    ".watchEffect() on a group of observable allows the same 'immediate' parameter as the .watchEffect() on a single observable",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      final effectParamValues = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, triggerRebuild) = _widget((context) {
        (valueNotifier, changeNotifier, stream).watchEffect(
          context,
          (valueNotifier, changeNotifier, snap) {
            effectParamValues.add((valueNotifier.value, null, snap));
          },
          immediate: true,
          key: 'effect',
        );
      });

      await tester.pumpWidget(widget);
      // Effect is called once immediately during the build since
      // the 'immediate' parameter is true
      expect(effectParamValues, [(0, null, const AsyncSnapshot.waiting())]);
      expect(rebuilds.value, 1);

      valueNotifier.value = 1;
      expect(effectParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      changeNotifier.notifyListeners();
      expect(effectParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      streamController.add(0);
      await Future.value(); // Let the stream notify
      expect(effectParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 1); // No rebuild

      triggerRebuild(() {});
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2); // Rebuild
      // No effects are called during rebuild
      expect(effectParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);
    },
  );

  testWidgets(
    ".unwatchEffect() on a group of observables triggers the .unwatchEffect() on each observable",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      var shouldWatchEffect = true;
      final effectParamValues = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, triggerRebuild) = _widget((context) {
        if (shouldWatchEffect) {
          (valueNotifier, changeNotifier, stream).watchEffect(
            context,
            (valueNotifier, changeNotifier, snap) {
              effectParamValues.add((valueNotifier.value, null, snap));
            },
            immediate: true,
            key: 'effect',
          );
        } else {
          (valueNotifier, changeNotifier, stream)
              .unwatchEffect(context, key: 'effect');
        }
      });

      await tester.pumpWidget(widget);
      // Effect is called once immediately during the build since
      // the 'immediate' parameter is true
      expect(effectParamValues, [(0, null, const AsyncSnapshot.waiting())]);
      expect(rebuilds.value, 1);

      streamController.add(0);
      await Future.value(); // Let the stream notify
      expect(effectParamValues, [
        (0, null, const AsyncSnapshot.waiting()),
        (0, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      triggerRebuild(() => shouldWatchEffect = false);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);

      valueNotifier.value = 1;
      changeNotifier.notifyListeners();
      streamController.add(0);
      await Future.value(); // Let the stream notify
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2); // No rebuild
      expect(effectParamValues, [
        // No new effect calls
        (0, null, const AsyncSnapshot.waiting()),
        (0, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);
    },
  );

  testWidgets(
    "(!) If .unwatchEffect() is called on a group of observables different than the one that was used to call .watchEffect(), missing observables are not unwatched",
    (tester) async {
      final valueNotifier = ValueNotifier(0);
      final changeNotifier = ChangeNotifier();
      final streamController = StreamController<int>();
      final stream = streamController.stream;

      var shouldWatchEffect = true;
      final effectParamValues = <(int, void, AsyncSnapshot<int>)>[];
      final (widget, rebuilds, triggerRebuild) = _widget((context) {
        if (shouldWatchEffect) {
          (valueNotifier, changeNotifier, stream).watchEffect(
            context,
            (valueNotifier, changeNotifier, snap) {
              effectParamValues.add((valueNotifier.value, null, snap));
            },
            key: 'effect',
          );
        } else {
          // Simulate we forgot to unwatch the [valueNotifier]
          (changeNotifier, stream).unwatchEffect(context, key: 'effect');
        }
      });

      await tester.pumpWidget(widget);
      expect(rebuilds.value, 1);

      valueNotifier.value = 1;
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      changeNotifier.notifyListeners();
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
      ]);

      streamController.add(0);
      await Future.value(); // Let the stream notify
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      triggerRebuild(() => shouldWatchEffect = false);
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);

      changeNotifier.notifyListeners();
      // [changeNotifier] is unwatched
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      streamController.add(1);
      await Future.value(); // Let the stream notify
      // [stream] is unwatched
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
      ]);

      valueNotifier.value = 2;
      // [valueNotifier] is **not** unwatched
      expect(effectParamValues, [
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.waiting()),
        (1, null, const AsyncSnapshot.withData(ConnectionState.active, 0)),
        // Not only the [valueNotifier] value updated, but the [stream]
        // value as well. That's because the observable subscription
        // is kept until all watch() calls are removed.
        (2, null, const AsyncSnapshot.withData(ConnectionState.active, 1)),
      ]);
    },
  );
}

(Widget, ValueListenable<int>, StateSetter triggerRebuild) _widget(
  void Function(BuildContext context) builder,
) {
  final rebuildsNotifier = ValueNotifier(0);
  late StateSetter triggerRebuild;
  return (
    ContextWatch.root(
      child: StatefulBuilder(
        builder: (context, setState) {
          triggerRebuild = setState;
          rebuildsNotifier.value++;
          builder(context);
          return const SizedBox.shrink();
        },
      ),
    ),
    rebuildsNotifier,
    (callback) => triggerRebuild(callback),
  );
}
