import 'package:context_watch/context_watch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'conditionally-invoked .watch() calls are unsubscribed after observable notification-related rebuild',
    (tester) async {
      var rebuilds = 0;
      final (notifier1, notifier2) = (ChangeNotifier(), ChangeNotifier());
      var (watch1, watch2) = (true, true);

      final builder = Builder(
        builder: (context) {
          context.dependOnInheritedWidgetOfExactType<_TestInheritedWidget>();
          rebuilds++;
          if (watch1) notifier1.watch(context);
          if (watch2) notifier2.watch(context);
          return const SizedBox.shrink();
        },
      );

      Widget widget({required String inherited}) {
        return ContextWatch.root(
          child: _TestInheritedWidget(
            value: inherited,
            child: builder,
          ),
        );
      }

      Future<void> notifyAndPump({
        required List<ChangeNotifier> notifiers,
        required int times,
      }) async {
        for (var i = 0; i < times; i++) {
          for (final notifier in notifiers) {
            notifier.notifyListeners();
          }
          await tester.pumpAndSettle();
        }
      }

      await tester.pumpWidget(widget(inherited: '0'));
      expect(rebuilds, 1);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 2);
      expect(rebuilds, 3);

      (watch1, watch2) = (false, true);
      await notifyAndPump(notifiers: [notifier1], times: 3);
      expect(rebuilds, 4);

      (watch1, watch2) = (true, false);
      await notifyAndPump(notifiers: [notifier2], times: 3);
      // [notifier2] triggered a rebuild during which the `notifier2.watch()` call was removed.
      // So, only one rebuild.
      expect(rebuilds, 5);

      (watch1, watch2) = (false, false);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // All `.watch()` calls were gone after the first rebuild, so only one rebuild.
      expect(rebuilds, 6);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // All `.watch()` calls were gone during the previous rebuild, so no rebuild via notifiers.
      // In fact, [watch1] and [watch2] values weren't even checked.
      expect(rebuilds, 6);

      (watch1, watch2) = (true, true);
      await tester.pumpWidget(widget(inherited: '1'));
      await tester.pumpWidget(widget(inherited: '2'));
      await tester.pumpWidget(widget(inherited: '3'));
      // The inherited widget caused the rebuild, all `.watch()` calls were re-invoked.
      expect(rebuilds, 9);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // Since `.watch()` calls were present in the last build, notifiers trigger rebuilds once again.
      expect(rebuilds, 12);
    },
  );

  testWidgets(
    'conditionally-invoked .watchOnly() calls are unsubscribed after observable notification-related rebuild',
    (tester) async {
      var rebuilds = 0;
      final (notifier1, notifier2) = (ChangeNotifier(), ChangeNotifier());
      var (watch1, watch2) = (true, true);

      final builder = Builder(
        builder: (context) {
          context.dependOnInheritedWidgetOfExactType<_TestInheritedWidget>();
          rebuilds++;
          // Always return a new object to make sure rebuild is not skipped.
          if (watch1) notifier1.watchOnly(context, (_) => Object());
          if (watch2) notifier2.watchOnly(context, (_) => Object());
          return const SizedBox.shrink();
        },
      );

      Widget widget({required String inherited}) {
        return ContextWatch.root(
          child: _TestInheritedWidget(
            value: inherited,
            child: builder,
          ),
        );
      }

      Future<void> notifyAndPump({
        required List<ChangeNotifier> notifiers,
        required int times,
      }) async {
        for (var i = 0; i < times; i++) {
          for (final notifier in notifiers) {
            notifier.notifyListeners();
          }
          await tester.pumpAndSettle();
        }
      }

      await tester.pumpWidget(widget(inherited: '0'));
      expect(rebuilds, 1);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 2);
      expect(rebuilds, 3);

      (watch1, watch2) = (false, true);
      await notifyAndPump(notifiers: [notifier1], times: 3);
      expect(rebuilds, 4);

      (watch1, watch2) = (true, false);
      await notifyAndPump(notifiers: [notifier2], times: 3);
      // [notifier2] triggered a rebuild during which the `notifier2.watch()` call was removed.
      // So, only one rebuild.
      expect(rebuilds, 5);

      (watch1, watch2) = (false, false);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // All `.watch()` calls were gone after the first rebuild, so only one rebuild.
      expect(rebuilds, 6);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // All `.watch()` calls were gone during the previous rebuild, so no rebuild via notifiers.
      // In fact, [watch1] and [watch2] values weren't even checked.
      expect(rebuilds, 6);

      (watch1, watch2) = (true, true);
      await tester.pumpWidget(widget(inherited: '1'));
      await tester.pumpWidget(widget(inherited: '2'));
      await tester.pumpWidget(widget(inherited: '3'));
      // The inherited widget caused the rebuild, all `.watch()` calls were re-invoked.
      expect(rebuilds, 9);

      (watch1, watch2) = (true, true);
      await notifyAndPump(notifiers: [notifier1, notifier2], times: 3);
      // Since `.watch()` calls were present in the last build, notifiers trigger rebuilds once again.
      expect(rebuilds, 12);
    },
  );
}

class _TestInheritedWidget extends InheritedWidget {
  const _TestInheritedWidget({
    required this.value,
    required super.child,
  });

  final String value;

  @override
  bool updateShouldNotify(_TestInheritedWidget oldWidget) =>
      oldWidget.value != value;
}
