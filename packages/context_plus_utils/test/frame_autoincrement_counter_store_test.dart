import 'package:context_plus/context_plus.dart';
import 'package:context_plus_utils/context_plus_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension UseStateExtension on BuildContext {
  static final _useKeyStoreRef = Ref<FrameAutoincrementCounterStore>();

  (T, ValueSetter<T>) useState<T>(T initialValue) {
    final store = _useKeyStoreRef.bind(
      this,
      FrameAutoincrementCounterStore.new,
      allowRebind: true,
    );

    final listenable = use(
      () => ValueNotifier(initialValue),
      key: store.getCounter(type: T),
    );
    return (listenable.watch(this), (T value) => listenable.value = value);
  }
}

// Test widget that uses useState
class _TestWidget extends StatelessWidget {
  const _TestWidget();

  @override
  Widget build(BuildContext context) {
    final (count, setCount) = context.useState(0);
    final (count2, setCount2) = context.useState(0);
    final (count3, setCount3) = context.useState(0);
    return Column(
      children: [
        Text('Count: $count'),
        Text('Count2: $count2'),
        Text('Count3: $count3'),
        ElevatedButton(
          onPressed: () => setCount(count + 1),
          child: const Text('Increment Count'),
        ),
        ElevatedButton(
          onPressed: () => setCount2(count2 + 1),
          child: const Text('Increment Count2'),
        ),
        ElevatedButton(
          onPressed: () => setCount3(count3 + 1),
          child: const Text('Increment Count3'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('useState hook works with FrameAutoincrementCounterStore', (
    tester,
  ) async {
    // Build the widget tree
    await tester.pumpWidget(
      ContextPlus.root(
        child: MaterialApp(home: Scaffold(body: const _TestWidget())),
      ),
    );

    // Initial state check
    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Count2: 0'), findsOneWidget);
    expect(find.text('Count3: 0'), findsOneWidget);

    // Test state update
    await tester.tap(find.text('Increment Count'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);
    expect(find.text('Count2: 0'), findsOneWidget);
    expect(find.text('Count3: 0'), findsOneWidget);

    // Test multiple state updates
    await tester.tap(find.text('Increment Count2'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);
    expect(find.text('Count2: 1'), findsOneWidget);
    expect(find.text('Count3: 0'), findsOneWidget);

    // Test state update
    await tester.tap(find.text('Increment Count3'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);
    expect(find.text('Count2: 1'), findsOneWidget);
    expect(find.text('Count3: 1'), findsOneWidget);

    // Test state update
    await tester.tap(find.text('Increment Count2'));
    await tester.tap(find.text('Increment Count3'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);
    expect(find.text('Count2: 2'), findsOneWidget);
    expect(find.text('Count3: 2'), findsOneWidget);
  });
}
