import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Future.watch(context) gives new AsyncSnapshot after after future completes with data',
    (widgetTester) async {
      final future = Future.value(0);
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatchRoot(
        child: Builder(
          builder: (context) {
            final snapshot = future.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );
      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
      ]);

      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.done, 0),
      ]);
    },
  );
  testWidgets(
    'Future.watch(context) gives new AsyncSnapshot after after future completes with error',
    (widgetTester) async {
      final error = Exception('error');

      Future<int>? future;
      StackTrace? trace;
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatchRoot(
        child: Builder(
          builder: (context) {
            trace ??= StackTrace.current;
            future ??= Future<int>.error(error, trace);
            final snapshot = future!.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );
      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
      ]);

      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
        AsyncSnapshot.withError(ConnectionState.done, error, trace!),
      ]);
    },
  );
  testWidgets(
    'SynchronousFuture<T>.watch(context) gives new AsyncSnapshot<T> with data right away',
    (widgetTester) async {
      final future = SynchronousFuture(0);
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatchRoot(
        child: Builder(
          builder: (context) {
            final snapshot = future.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );
      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        const AsyncSnapshot.withData(ConnectionState.done, 0),
      ]);
    },
  );
}
