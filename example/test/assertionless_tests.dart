import 'dart:io';

import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

final _intRef = Ref<int>();

// Run with `flutter run --profile test/assertionless_tests.dart -d macos`
void main() {
  assert(false); // fail in debug mode

  LiveTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() {
    exit(0);
  });

  testWidgets('Ref.bindValue() inside callback', (tester) async {
    int valueToBind = 0;

    bool shouldReadValue = false;
    int? valueRead;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Binding in the callback, on anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work.
          _intRef.bindValue(context, valueToBind);
        },
        child: Builder(
          builder: (context) {
            if (shouldReadValue) {
              valueRead = _intRef.of(context);
            }
            return const Text('Button');
          },
        ),
      );
    });

    // Bind the initial value, 0
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, isNull);

    // Actually start observing the previously bound Ref
    setState(() {
      shouldReadValue = true;
    });
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 0);

    // Bind the new value, 1
    valueToBind = 1;
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 1);
  });

  testWidgets('Ref.bind() inside callback', (tester) async {
    int valueToBind = 0;

    bool shouldReadValue = false;
    int? valueRead;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Binding in the callback, on anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work.
          _intRef.bind(context, () => valueToBind, key: valueToBind);
        },
        child: Builder(
          builder: (context) {
            if (shouldReadValue) {
              valueRead = _intRef.of(context);
            }
            return const Text('Button');
          },
        ),
      );
    });

    // Bind the initial value, 0
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, isNull);

    // Actually start observing the previously bound Ref
    setState(() {
      shouldReadValue = true;
    });
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 0);

    // Bind the new value, 1
    valueToBind = 1;
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 1);
  });

  testWidgets('Ref.bindLazy() inside callback', (tester) async {
    int valueToBind = 0;

    bool shouldReadValue = false;
    int? valueRead;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Binding in the callback, on anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work.
          _intRef.bindLazy(context, () => valueToBind, key: valueToBind);
        },
        child: Builder(
          builder: (context) {
            if (shouldReadValue) {
              valueRead = _intRef.of(context);
            }
            return const Text('Button');
          },
        ),
      );
    });

    // Bind the initial value, 0
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, isNull);

    // Actually start observing the previously bound Ref
    setState(() {
      shouldReadValue = true;
    });
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 0);

    // Bind the new value, 1
    valueToBind = 1;
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(valueRead, 1);
  });

  testWidgets('ValueNotifier.watch() inside callback', (tester) async {
    final intNotifier = ValueNotifier<int>(0);
    int? observedValue;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Watching in the callback, or anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work
          // and add the context subscription.
          observedValue = intNotifier.watch(context);
        },
        child: const Text('Button'),
      );
    });
    expect(rebuilds.value, 1);

    // Trigger .watch() for the first time
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(observedValue, 0);
    expect(rebuilds.value, 1);

    intNotifier.value = 1;
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(rebuilds.value, 2);
  });

  testWidgets('ValueNotifier.watchOnly() inside callback', (tester) async {
    final intNotifier = ValueNotifier<int>(0);
    int? observedValue;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Watching in the callback, or anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work
          // and add the context subscription.
          observedValue = intNotifier.watchOnly(context, (value) => value * 2);
        },
        child: const Text('Button'),
      );
    });
    expect(rebuilds.value, 1);

    // Trigger .watchOnly() for the first time
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(observedValue, 0);
    expect(rebuilds.value, 1);

    intNotifier.value = 1;
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(rebuilds.value, 2);
  });

  testWidgets('ValueNotifier.watchEffect() inside callback', (tester) async {
    final intNotifier = ValueNotifier<int>(0);
    int? observedValue;

    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      return TextButton(
        key: const Key('button'),
        onPressed: () {
          // Watching in the callback, or anywhere else outside the build method
          // triggers an assertion error. In release mode, though, it will work
          // and add the context subscription.
          intNotifier.watchEffect(context, (value) => observedValue = value);
        },
        child: const Text('Button'),
      );
    });
    expect(observedValue, isNull);
    expect(rebuilds.value, 1);

    // Register .watchEffect() for the first time
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    var exception = tester.takeException();
    expect(exception, isNull);
    expect(rebuilds.value, 1);
    expect(observedValue, isNull);

    intNotifier.value = 1;
    await tester.pumpAndSettle();
    exception = tester.takeException();
    expect(exception, isNull);
    expect(rebuilds.value, 1);
    expect(observedValue, 1);
  });
}
