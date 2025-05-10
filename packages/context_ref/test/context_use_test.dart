import 'package:context_ref/context_ref.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets('can use single value', (WidgetTester tester) async {
    final values = Set<Object>.identity();
    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      final value = context.use(() => Value(0));
      values.add(value);
      return const SizedBox.shrink();
    });
    expect(rebuilds.value, 1);
    expect(values, hasLength(1));

    setState(() {});
    await tester.pumpAndSettle();
    expect(rebuilds.value, 2);
    // Stream is not recreated, instance stays the same
    expect(values, hasLength(1));
  });

  testWidgets('changing the type of used value results in a new instance creation', (
    WidgetTester tester,
  ) async {
    final values = Set<Object>.identity();
    Object? latestValue;

    bool useAsObject = false;
    bool useAsObjectViaGeneric = false;
    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      if (useAsObject) {
        final value = context.use<Object>(() => Value(0));
        latestValue = value;
        values.add(value);
      } else if (useAsObjectViaGeneric) {
        final value = context.use(() => Value<Object>(0));
        latestValue = value;
        values.add(value);
      } else {
        final value = context.use(() => Value(0));
        latestValue = value;
        values.add(value);
      }
      return const SizedBox.shrink();
    });
    expect(rebuilds.value, 1);
    // Value<int> is provided as Value<int>.
    expect(values, hasLength(1));

    setState(() {
      useAsObject = true;
      useAsObjectViaGeneric = false;
    });
    await tester.pumpAndSettle();
    expect(rebuilds.value, 2);
    // Value<int> is provided as Object, new object instance is created.
    expect(values, hasLength(2));

    setState(() {
      useAsObject = false;
      useAsObjectViaGeneric = false;
    });
    await tester.pumpAndSettle();
    expect(rebuilds.value, 3);
    expect(values, hasLength(3));
    // Value<int> is provided as Value<int> again, but new object instance is created.
    expect(latestValue, isNot(values.first));

    setState(() {
      useAsObject = false;
      useAsObjectViaGeneric = true;
    });
    await tester.pumpAndSettle();
    expect(rebuilds.value, 4);
    // Value<int> is provided as Value<Object>, new object instance is created.
    expect(values, hasLength(4));

    setState(() {
      useAsObject = false;
      useAsObjectViaGeneric = false;
    });
    await tester.pumpAndSettle();
    expect(rebuilds.value, 5);
    expect(values, hasLength(5));
    // Value<int> is provided as Value<int> once again, but new object instance is created.
    expect(latestValue, isNot(values.first));
  });

  testWidgets('can use multiple values of different types', (
    WidgetTester tester,
  ) async {
    final values = Set<Object>.identity();
    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      final value1 = context.use(() => Value(1));
      final value2 = context.use(() => Value('String'));
      values.add(value1);
      values.add(value2);
      return const SizedBox.shrink();
    });
    expect(rebuilds.value, 1);
    // Two different objects are created.
    expect(values, hasLength(2));

    setState(() {});
    await tester.pumpAndSettle();
    expect(rebuilds.value, 2);
    // No new objects are created after rebuild.
    expect(values, hasLength(2));
  });

  testWidgets(
    'can_not use multiple values of the same type without different key or ref',
    (WidgetTester tester) async {
      await pumpWidget(tester, (context) {
        context.use(() => Value(1));
        context.use(() => Value(2));
        return const SizedBox.shrink();
      });

      final exception = tester.takeException();
      expect(exception, isAssertionError);
      expect(
        (exception as AssertionError).message,
        'Each context.use() call for a given BuildContext must have a different combination of return type, `key` and `ref` parameters. See https://pub.dev/packages/context_ref#use-parameter-combinations for more details.',
      );
    },
  );

  testWidgets(
    'can use multiple values of the same type with different keys along with values of other types',
    (WidgetTester tester) async {
      final values = Set<Object>.identity();
      final (rebuilds, setState) = await pumpWidget(tester, (context) {
        final value1 = context.use(() => Value(1), key: 'value1');
        final value2 = context.use(() => Value(2), key: 'value2');
        final value3 = context.use(() => Value('Hello'));
        values.add(value1);
        values.add(value2);
        values.add(value3);
        return const SizedBox.shrink();
      });
      expect(rebuilds.value, 1);
      // Three different objects are created.
      expect(values, hasLength(3));

      setState(() {});
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);
      // No new objects are created after rebuild.
      expect(values, hasLength(3));
    },
  );

  testWidgets(
    'can use multiple values of the same type with different refs along with values of other types',
    (WidgetTester tester) async {
      final ref1 = Ref<Value<int>>();
      final ref2 = Ref<Value<int>>();

      final values = Set<Object>.identity();
      final (rebuilds, setState) = await pumpWidget(tester, (context) {
        final value1 = context.use(() => Value(1), ref: ref1);
        final value2 = context.use(() => Value(2), ref: ref2);
        final value3 = context.use(() => Value('Hello'));
        values.add(value1);
        values.add(value2);
        values.add(value3);
        return const SizedBox.shrink();
      });
      expect(rebuilds.value, 1);
      // Three different objects are created.
      expect(values, hasLength(3));

      setState(() {});
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);
      // No new objects are created after rebuild.
      expect(values, hasLength(3));
    },
  );

  testWidgets('key change disposes the previous provider early', (
    WidgetTester tester,
  ) async {
    var key = '1';
    var createCalls = 0;
    var disposeCalls = 0;
    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      context.use(
        () {
          createCalls++;
          return Object();
        },
        dispose: (_) {
          disposeCalls++;
        },
        key: key,
      );
      return const SizedBox.shrink();
    });
    expect(createCalls, 1);
    expect(disposeCalls, 0);

    setState(() {
      key = '2';
    });
    await tester.pumpAndSettle();
    expect(createCalls, 2);
    expect(disposeCalls, 1);

    setState(() {
      key = '1';
    });
    await tester.pumpAndSettle();
    expect(createCalls, 3);
    expect(disposeCalls, 2);
  });

  testWidgets(
    'context.use() removal from build method disposes the previous provider early',
    (WidgetTester tester) async {
      var useKey1 = true;
      var useKey2 = true;
      var useKey3 = true;

      final createdKeys = <String>[];
      final disposedKeys = <String>[];
      final (rebuilds, setState) = await pumpWidget(tester, (context) {
        if (useKey1) {
          context.use(
            () {
              createdKeys.add('1');
              return Object();
            },
            dispose: (_) => disposedKeys.add('1'),
            key: '1',
          );
        }
        if (useKey2) {
          context.use(
            () {
              createdKeys.add('2');
              return Object();
            },
            dispose: (_) => disposedKeys.add('2'),
            key: '2',
          );
        }
        if (useKey3) {
          context.use(
            () {
              createdKeys.add('3');
              return Object();
            },
            dispose: (_) => disposedKeys.add('3'),
            key: '3',
          );
        }
        return const SizedBox.shrink();
      });
      expect(createdKeys, ['1', '2', '3']);
      expect(disposedKeys, isEmpty);

      setState(() {});
      await tester.pumpAndSettle();
      expect(createdKeys, ['1', '2', '3']);
      expect(disposedKeys, isEmpty);

      setState(() {
        useKey1 = true;
        useKey2 = false;
        useKey3 = true;
      });
      await tester.pumpAndSettle();
      expect(createdKeys, ['1', '2', '3']);
      expect(disposedKeys, ['2']);

      setState(() {
        useKey1 = false;
        useKey2 = false;
        useKey3 = false;
      });
      await tester.pumpAndSettle();
      expect(createdKeys, ['1', '2', '3']);
      // All `context.use()` calls are removed, so no we don't know that rebuild has happened.
      // So, nothing is disposed yet.
      expect(disposedKeys, ['2']);

      setState(() {
        useKey1 = false;
        useKey2 = true;
        useKey3 = true;
      });
      await tester.pumpAndSettle();
      // key3 wasn't recreated, since we didn't know that it was removed in the previous rebuild,
      // and was present once again during the current rebuild.
      expect(createdKeys, ['1', '2', '3', '2']);
      // key2 and key3 are in use again. Only key1 is disposed, though, since we didn't know
      // about the previous rebuild where key3 was gone.
      expect(disposedKeys, ['2', '1']);
    },
  );

  testWidgets('used values are disposed when the context is disposed', (
    WidgetTester tester,
  ) async {
    var useValue1 = true;
    var useValue2 = true;

    var createCalls = 0;
    var disposeCalls = 0;
    var requestDispose = false;
    final (rebuilds, setState) = await pumpWidget(tester, (context) {
      if (requestDispose) {
        return const SizedBox.shrink();
      }
      return Builder(
        builder: (context) {
          if (useValue1) {
            context.use(() {
              createCalls++;
              return 1;
            }, dispose: (_) => disposeCalls++);
          }
          if (useValue2) {
            context.use(() {
              createCalls++;
              return '2';
            }, dispose: (_) => disposeCalls++);
          }
          return const SizedBox.shrink();
        },
      );
    });
    expect(createCalls, 2);
    expect(disposeCalls, 0);

    setState(() {
      useValue1 = false;
    });
    await tester.pumpAndSettle();
    expect(createCalls, 2);
    expect(disposeCalls, 1);

    setState(() {
      useValue1 = true;
    });
    await tester.pumpAndSettle();
    expect(createCalls, 3);
    expect(disposeCalls, 1);

    setState(() {
      requestDispose = true;
    });
    await tester.pumpAndSettle();
    expect(createCalls, 3);
    expect(disposeCalls, 3);
  });
}
