import 'package:async_listenable/async_listenable.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AsyncListenable.watch()', (tester) async {
    final asyncNotifier = AsyncNotifier<int>();

    final snapshots = <AsyncSnapshot<int>>[];
    await tester.pumpWidget(
      ContextWatch.root(
        child: Builder(
          builder: (context) {
            final snapshot = asyncNotifier.watchValue(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(snapshots, hasLength(1));
    expect(snapshots.last.connectionState, ConnectionState.none);
    expect(snapshots.last.data, null);

    asyncNotifier.setFuture(Future.value(42));
    await tester.pump();
    expect(snapshots, hasLength(2));
    expect(snapshots.last.connectionState, ConnectionState.done);
    expect(snapshots.last.data, 42);
  });
}
