import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  setUp(() {
    _counterRef = Ref<int>();
    _CounterWidget.widgetBuilds = 0;
  });

  testWidgets(
    'Ref.bind() returns the same value, no matter how many times it is called',
    (widgetTester) async {
      final (value1Ref, value2Ref, value3Ref) = (
        Ref<int>(),
        Ref<int>(),
        Ref<int>(),
      );
      var (useValue1, useValue2, useValue3) = (
        ValueNotifier(false),
        ValueNotifier(false),
        ValueNotifier(false),
      );
      final valueRecords = <(int?, int?, int?)>[];
      int generatedIndex = 0;
      final valueGenerations = [0, 0, 0];
      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder: (context) {
                var (value1, value2, value3) = (null, null, null);
                if (useValue1.watch(context)) {
                  value1 = value1Ref.bind(context, () {
                    valueGenerations[0]++;
                    return generatedIndex++;
                  });
                }
                if (useValue2.watch(context)) {
                  value2 = value2Ref.bind(context, () {
                    valueGenerations[1]++;
                    return generatedIndex++;
                  });
                }
                if (useValue3.watch(context)) {
                  value3 = value3Ref.bind(context, () {
                    valueGenerations[2]++;
                    return generatedIndex++;
                  });
                }
                valueRecords.add((value1, value2, value3));
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(valueGenerations, [0, 0, 0]);

      useValue1.value = true;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 0, 0]);

      useValue2.value = true;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 1, 0]);

      useValue3.value = true;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 1, 1]);

      useValue1.value = false;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 1, 1]);

      useValue2.value = false;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 1, 1]);

      useValue3.value = false;
      await widgetTester.pumpAndSettle();
      expect(valueGenerations, [1, 1, 1]);

      expect(valueRecords, [
        (null, null, null),
        (0, null, null),
        (0, 1, null),
        (0, 1, 2),
        (null, 1, 2),
        (null, null, 2),
        (null, null, null),
      ]);
    },
  );

  testWidgets('Ref.bind(key: ) allows to update the value provider', (
    widgetTester,
  ) async {
    int index = 0;
    int providerCalls = 0;
    int builds = 0;
    final returnedValues = <int>[];
    final buildRequest = ChangeNotifier();
    final valueRef = Ref<int>();

    Object? key;
    await widgetTester.pumpWidget(
      ContextWatch.root(
        child: ContextRef.root(
          child: Builder(
            builder: (context) {
              buildRequest.watch(context);
              builds++;
              final value = valueRef.bind(context, () {
                providerCalls++;
                return index++;
              }, key: key);
              returnedValues.add(value);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    expect(builds, 1);
    expect(providerCalls, 1);
    expect(returnedValues, [0]);

    // If key didn't change, the value provider is not called again
    buildRequest.notifyListeners();
    await widgetTester.pumpAndSettle();
    expect(builds, 2);
    expect(providerCalls, 1);
    expect(returnedValues, [0, 0]);

    // If key changes, the value provider is called again
    key = Object();
    buildRequest.notifyListeners();
    await widgetTester.pumpAndSettle();
    expect(builds, 3);
    expect(providerCalls, 2);
    expect(returnedValues, [0, 0, 1]);

    // After the key change, if the build request is triggered again, the value
    // provider is not called again
    buildRequest.notifyListeners();
    await widgetTester.pumpAndSettle();
    expect(builds, 4);
    expect(providerCalls, 2);
    expect(returnedValues, [0, 0, 1, 1]);
  });

  testWidgets(
    'Ref.bind(key: ) rebuilds all dependent widgets when the key changes',
    (widgetTester) async {
      final ref = Ref<Object>();
      Object? key;

      late Object boundObject;
      late Object observedObject;

      var parentBuilds = 0;
      var childBuilds = 0;

      late Function(Function()) parentSetState;

      final child = StatefulBuilder(
        builder: (context, setState) {
          childBuilds++;
          observedObject = ref.of(context);
          return const SizedBox.shrink();
        },
      );

      final parent = StatefulBuilder(
        builder: (context, setState) {
          parentBuilds++;
          parentSetState = setState;
          ref.bind(context, () {
            boundObject = Object();
            return boundObject;
          }, key: key);
          return child;
        },
      );

      await widgetTester.pumpWidget(ContextRef.root(child: parent));
      expect(parentBuilds, 1);
      expect(childBuilds, 1);
      expect(boundObject, same(observedObject));

      key = 2;
      parentSetState(() {});
      await widgetTester.pumpAndSettle();
      expect(parentBuilds, 2);
      // Rebuild child since the key changed
      expect(childBuilds, 2);
      expect(boundObject, same(observedObject));

      key = [3];
      parentSetState(() {});
      await widgetTester.pumpAndSettle();
      expect(parentBuilds, 3);
      // Rebuild child since the key changed
      expect(childBuilds, 3);
      expect(boundObject, same(observedObject));

      key = [4];
      parentSetState(() {});
      await widgetTester.pumpAndSettle();
      expect(parentBuilds, 4);
      // Rebuild child since key's list elements changed
      expect(childBuilds, 4);
      expect(boundObject, same(observedObject));

      key = [4];
      parentSetState(() {});
      await widgetTester.pumpAndSettle();
      expect(parentBuilds, 5);
      // No child rebuild since key's list elements didn't change
      expect(childBuilds, 4);
      expect(boundObject, same(observedObject));
    },
  );

  testWidgets(
    'Ref.bind(key: ) disposes old value right away upon changing a key',
    (widgetTester) async {
      final valueRef = Ref<_TestChangeNotifier>();
      final buildRequest = ChangeNotifier();

      late _TestChangeNotifier providedNotifier;
      Object? key;
      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder: (context) {
                buildRequest.watch(context);
                providedNotifier = valueRef.bind(
                  context,
                  () => _TestChangeNotifier(),
                  key: key,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(providedNotifier.isDisposed, false);

      // If key didn't change, the value is not disposed
      final oldProvidedNotifier1 = providedNotifier;
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(providedNotifier, oldProvidedNotifier1);
      expect(providedNotifier.isDisposed, false);

      // If key changes, the old value is disposed
      key = Object();
      final oldProvidedNotifier2 = providedNotifier;
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(providedNotifier, isNot(oldProvidedNotifier2));
      expect(oldProvidedNotifier2.isDisposed, true);

      // After the key change, if the build request is triggered again, the value
      // provider is not called again
      final oldProvidedNotifier3 = providedNotifier;
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(providedNotifier, oldProvidedNotifier3);
    },
  );

  testWidgets(
    'Ref.bind(key: ) performs deep comparison on Lists, Maps and Sets',
    (widgetTester) async {
      int builds = 0;
      int providerCalls = 0;

      final buildRequest = ChangeNotifier();
      final valueRef = Ref<int>();

      Object? Function() buildKey = () => [1];
      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder: (context) {
                builds++;
                buildRequest.watch(context);
                valueRef.bind(context, () {
                  providerCalls++;
                  return 0;
                }, key: buildKey());
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(builds, 1);
      expect(providerCalls, 1);

      // If List key values didn't change - the provider is not triggered again
      buildKey = () => [1];
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 2);
      expect(providerCalls, 1);

      // If List key values did change - the provider is triggered again
      buildKey = () => [1, 2];
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 3);
      expect(providerCalls, 2);

      // If key type changes - the provider is triggered again
      buildKey = () => {1, 2};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 4);
      expect(providerCalls, 3);

      // If Set key values didn't change - the provider is not triggered again
      buildKey = () => {1, 2};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 5);
      expect(providerCalls, 3);

      // If Set key values did change - the provider is triggered again
      buildKey = () => {1, 2, 3};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 6);
      expect(providerCalls, 4);

      // If key type changes - the provider is triggered again
      buildKey = () => {'a': 1, 'b': 2, 'c': 3};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 7);
      expect(providerCalls, 5);

      // If Map key values didn't change - the provider is not triggered again
      buildKey = () => {'a': 1, 'b': 2, 'c': 3};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 8);
      expect(providerCalls, 5);

      // If Map key values did change - the provider is triggered again
      buildKey = () => {'a': 1, 'b': 2, 'c': 4};
      buildRequest.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(builds, 9);
      expect(providerCalls, 6);
    },
  );

  testWidgets('Ref.bindLazy() initializes the value lazily and only once', (
    widgetTester,
  ) async {
    int generatedIndex = 0;
    var valueInitializations = 0;
    final valueRef = Ref<int>();

    await widgetTester.pumpWidget(
      ContextRef.root(
        child: Builder(
          builder: (context) {
            valueRef.bindLazy(context, () {
              valueInitializations++;
              return generatedIndex++;
            });
            final value1 = valueRef.of(context);
            final value2 = valueRef.of(context);
            final value3 = valueRef.of(context);
            expect(value1, value2);
            expect(value2, value3);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(valueInitializations, 1);
  });

  testWidgets(
    'Ref.bindValue() marks child elements as dirty when the value changes',
    (widgetTester) async {
      final valueToProvide = ValueNotifier<int>(0);
      var providerRebuilds = 0;
      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder: (context) {
                final value = valueToProvide.watch(context);
                _counterRef.bindValue(context, value);
                providerRebuilds++;

                /// Must be const to ensure that [_CounterWidget]'s element
                /// is_not rebuilt when the provider is rebuilt, only when
                /// the child element is marked dirty.
                return const _CounterWidget();
              },
            ),
          ),
        ),
      );
      expect(providerRebuilds, 1);
      expect(_CounterWidget.widgetBuilds, 1);

      // If the provided value changes, the dependent widget rebuilds
      valueToProvide.value++;
      await widgetTester.pumpAndSettle();
      expect(providerRebuilds, 2);
      expect(_CounterWidget.widgetBuilds, 2);

      // If the provided value changes again, the dependent widget rebuilds again
      valueToProvide.value++;
      await widgetTester.pumpAndSettle();
      expect(providerRebuilds, 3);
      expect(_CounterWidget.widgetBuilds, 3);

      // If the provided value doesn't change, the dependent widget doesn't rebuild
      valueToProvide.notifyListeners();
      await widgetTester.pumpAndSettle();
      expect(providerRebuilds, 4);
      expect(_CounterWidget.widgetBuilds, 3);
    },
  );

  testWidgets(
    'Ref.of(context) gets the value from the closest parent context, including the current one',
    (widgetTester) async {
      final providerDepth = ValueNotifier<int>(1);

      var observedValue = 0;
      final childWidget = Builder(
        builder: (context) {
          observedValue = _counterRef.of(context);
          return const SizedBox.shrink();
        },
      );

      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder: (context) {
                final depth = providerDepth.watch(context);
                if (depth >= 1) {
                  _counterRef.bindValue(context, 1);
                }
                return Builder(
                  builder: (context) {
                    final depth = providerDepth.watch(context);
                    if (depth >= 2) {
                      _counterRef.bindValue(context, 2);
                    }
                    return Builder(
                      builder: (context) {
                        final depth = providerDepth.watch(context);
                        if (depth >= 3) {
                          _counterRef.bindValue(context, 3);
                        }
                        return childWidget;
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      expect(observedValue, 1);

      providerDepth.value = 2;
      await widgetTester.pumpAndSettle();
      expect(observedValue, 2);

      providerDepth.value = 3;
      await widgetTester.pumpAndSettle();
      expect(observedValue, 3);
    },
  );

  testWidgets(
    'Ref.of(context) correctly reacts to the GlobalKey re-parenting',
    (widgetTester) async {
      final selectedProvider = ValueNotifier<int>(1);

      var observedValue = 0;
      final childWidget = Builder(
        key: GlobalKey(debugLabel: 'child'),
        builder: (context) {
          observedValue = _counterRef.of(context);
          return const SizedBox.shrink();
        },
      );

      await widgetTester.pumpWidget(
        ContextWatch.root(
          child: ContextRef.root(
            child: Builder(
              builder:
                  (context) => Stack(
                    textDirection: TextDirection.ltr,
                    children: [
                      if (selectedProvider.watch(context) == 1)
                        Builder(
                          builder: (context) {
                            _counterRef.bindValue(context, 1);
                            return childWidget;
                          },
                        ),
                      if (selectedProvider.watch(context) == 2)
                        Builder(
                          builder: (context) {
                            _counterRef.bindValue(context, 2);
                            return childWidget;
                          },
                        ),
                      if (selectedProvider.watch(context) == 3)
                        Builder(
                          builder: (context) {
                            _counterRef.bindValue(context, 3);
                            return childWidget;
                          },
                        ),
                    ],
                  ),
            ),
          ),
        ),
      );
      expect(observedValue, 1);

      selectedProvider.value = 2;
      await widgetTester.pumpAndSettle();
      expect(observedValue, 2);

      selectedProvider.value = 3;
      await widgetTester.pumpAndSettle();
      expect(observedValue, 3);
    },
  );

  testWidgets('Ref.bind() handles the GlobalKey re-parenting (1)', (
    widgetTester,
  ) async {
    final returnChildImmediately = ValueNotifier(true);
    final ref = Ref<Object>();
    final globalKey = GlobalKey();

    var disposeCalls = 0;
    void onDisposeRef() {
      disposeCalls++;
    }

    await widgetTester.pumpWidget(
      ContextWatch.root(
        child: ContextRef.root(
          child: Builder(
            builder: (context) {
              if (returnChildImmediately.watch(context)) {
                return _ReparentedChild(
                  key: globalKey,
                  ref: ref,
                  onDisposeRef: onDisposeRef,
                );
              }
              return SizedBox(
                child: _ReparentedChild(
                  key: globalKey,
                  ref: ref,
                  onDisposeRef: onDisposeRef,
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(disposeCalls, 0);

    returnChildImmediately.value = false;
    await widgetTester.pumpAndSettle();
    expect(disposeCalls, 0);
  });

  testWidgets('Ref.bind() handles the GlobalKey re-parenting (2)', (
    widgetTester,
  ) async {
    final returnChildImmediately = ValueNotifier(true);
    final ref = Ref<Object>();
    final globalKey = GlobalKey();

    var disposeCalls = 0;
    void onDisposeRef() {
      disposeCalls++;
    }

    await widgetTester.pumpWidget(
      ContextWatch.root(
        child: ContextRef.root(
          child: Builder(
            builder: (context) {
              if (returnChildImmediately.watch(context)) {
                return SizedBox(
                  key: globalKey,
                  child: _ReparentedChild(ref: ref, onDisposeRef: onDisposeRef),
                );
              }
              return Center(
                child: SizedBox(
                  key: globalKey,
                  child: _ReparentedChild(ref: ref, onDisposeRef: onDisposeRef),
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(disposeCalls, 0);

    returnChildImmediately.value = false;
    await widgetTester.pumpAndSettle();
    expect(disposeCalls, 0);
  });

  testWidgets(
    'Ref may not be bound to the same BuildContext more than once in a single build()',
    (tester) async {
      final ref = Ref<Object>();

      // The pumpWidget call is expected to cause an assertion error.
      await pumpWidget(tester, (context) {
        ref.bind(context, () => Object());
        // This second bind call should throw.
        ref.bind(context, () => Object());
        return const SizedBox.shrink();
      });
      final exception = tester.takeException();
      expect(exception, isA<AssertionError>());
      expect(
        (exception as AssertionError).message,
        'Ref may not be bound to the same BuildContext more than once in a single build()',
      );

      await pumpWidget(tester, (context) {
        // This should not throw.
        context.use(() => Object());
        return const SizedBox.shrink();
      });
      final exception2 = tester.takeException();
      expect(exception2, isNull);
    },
  );
}

class _TestChangeNotifier extends ChangeNotifier {
  bool isDisposed = false;

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}

late Ref<int> _counterRef;

class _CounterWidget extends StatelessWidget {
  const _CounterWidget();

  static var widgetBuilds = 0;

  @override
  Widget build(BuildContext context) {
    _counterRef.of(context);
    widgetBuilds++;
    return const Placeholder();
  }
}

class _ReparentedChild extends StatelessWidget {
  const _ReparentedChild({
    super.key,
    required this.ref,
    required this.onDisposeRef,
  });

  final Ref<Object> ref;
  final VoidCallback onDisposeRef;

  @override
  Widget build(BuildContext context) {
    ref.bind(context, () => Object(), dispose: (_) => onDisposeRef());
    return const SizedBox.shrink();
  }
}
