import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'watchEffect() calls the callback when the observable value changes, without rebuilding the widget',
      (tester) async {
    final notifier = ValueNotifier(0);
    var effectCalls = 0;
    final (widget, rebuilds) = _widget((context) {
      notifier.watchEffect(context, (_) => effectCalls++);
      return const SizedBox.shrink();
    });

    await tester.pumpWidget(widget);
    expect(effectCalls, 0);
    expect(rebuilds.value, 1);

    notifier.value = 1;
    await tester.pumpAndSettle();
    expect(effectCalls, 1);
    expect(rebuilds.value, 1);

    notifier.value = 2;
    await tester.pumpAndSettle();
    expect(effectCalls, 2);
    expect(rebuilds.value, 1);

    notifier.value = 3;
    notifier.value = 4;
    notifier.value = 5;
    // Effect is called on each value change, even though no vsync has even happened
    expect(effectCalls, 5);
    expect(rebuilds.value, 1);
  });

  testWidgets(
      'watchEffect() can be conditionally enabled/disabled by including/excluding it from the build method',
      (tester) async {
    final notifier = ValueNotifier(Object());
    var effectCalls = 0;
    final shouldWatchEffect = ValueNotifier(false);
    final (widget, rebuilds) = _widget(
      (context) {
        if (shouldWatchEffect.watch(context)) {
          notifier.watchEffect(context, (_) => effectCalls++);
        }
        return const SizedBox.shrink();
      },
    );

    await tester.pumpWidget(widget);
    expect(effectCalls, 0);
    expect(rebuilds.value, 1);

    shouldWatchEffect.value = true;
    // Rebuild the widget to enable the side effect
    await tester.pumpAndSettle();
    expect(effectCalls, 0);
    expect(rebuilds.value, 2);
    // Update the watched value to trigger change notification
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(effectCalls, 1); // The side effect is called again
    expect(rebuilds.value, 2); // No rebuild is triggered

    shouldWatchEffect.value = false;
    // Rebuild the widget to disable the side effect
    await tester.pumpAndSettle();
    expect(effectCalls, 1);
    expect(rebuilds.value, 3);
    // Update the watched value to trigger change notification
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(effectCalls, 1); // The side effect is *not* called
    expect(rebuilds.value, 3); // Rebuild is *not* triggered
  });

  testWidgets(
      'multiple watchEffect() can be registered/unregistered dynamically for the same observable',
      (tester) async {
    final notifier = ValueNotifier(Object());
    var effectCalls = [0, 0];
    final watchedEffects = ValueNotifier(const {0, 1});
    final (widget, rebuilds) = _widget((context) {
      final effects = watchedEffects.watch(context);
      if (effects.contains(0)) {
        notifier.watchEffect(context, (_) {
          effectCalls[0] += 1;
        });
      }
      if (effects.contains(1)) {
        notifier.watchEffect(context, (_) {
          effectCalls[1] += 1;
        });
      }
      return const SizedBox.shrink();
    });

    await tester.pumpWidget(widget);
    expect(rebuilds.value, 1);
    expect(effectCalls, [0, 0]);

    // Update the watched value to trigger multiple change notifications
    notifier.value = Object();
    notifier.value = Object();
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(rebuilds.value, 1); // No rebuild
    expect(effectCalls, [3, 3]); // Effect is called on each value change

    watchedEffects.value = const {1}; // Stop watching effect #0
    await tester.pumpAndSettle(); // Rebuild to update watched effects
    expect(rebuilds.value, 2);
    // Update the watched value to trigger multiple change notifications
    notifier.value = Object();
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(rebuilds.value, 2); // No rebuild
    expect(effectCalls, [3, 5]); // Only effect #1 is called

    watchedEffects.value = const {}; // Stop watching all effect
    await tester.pumpAndSettle(); // Rebuild to update watched effects
    expect(rebuilds.value, 3);
    // Update the watched value to trigger multiple change notifications
    notifier.value = Object();
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(rebuilds.value, 3); // No rebuild
    expect(effectCalls, [3, 5]); // No more effect calls

    watchedEffects.value = const {0}; // Watch effect #0 again
    await tester.pumpAndSettle(); // Rebuild to update watched effects
    expect(rebuilds.value, 4);
    // Update the watched value to trigger multiple change notifications
    notifier.value = Object();
    notifier.value = Object();
    await tester.pumpAndSettle(); // Trigger vsync
    expect(rebuilds.value, 4); // No rebuild
    expect(effectCalls, [5, 5]); // Side effect #0 is called again
  });

  group('conditional effect removal', () {
    testWidgets(
        'watchEffect() can be removed after non-.watch*()-related rebuild using .unwatchEffect()',
        (tester) async {
      final notifier = ValueNotifier(Object());
      var effectCalls = 0;
      var shouldWatchEffect = true;
      final (widget, rebuilds) = _widget(
        (context) {
          _Inherited.of(context);
          if (shouldWatchEffect) {
            notifier.watchEffect(context, (_) => effectCalls++, key: 'effect');
          } else {
            notifier.unwatchEffect(context, key: 'effect');
          }
          return const SizedBox.shrink();
        },
      );

      await tester.pumpWidget(
        _Inherited(
          value: 0,
          child: widget,
        ),
      );
      expect(effectCalls, 0);
      expect(rebuilds.value, 1);

      notifier.value = Object();
      notifier.value = Object();
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 1); // No rebuild
      expect(effectCalls, 2); // Side effect is called for each value change

      shouldWatchEffect = false;
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 1); // No rebuild
      expect(effectCalls, 2); // No new effect calls

      // Force a rebuild to update the watched effect
      await tester.pumpWidget(
        _Inherited(
          value: 1,
          child: widget,
        ),
      );
      expect(rebuilds.value, 2); // Rebuild
      expect(effectCalls, 2); // Side effects are not called

      notifier.value = Object();
      notifier.value = Object();
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 2); // No rebuild
      expect(effectCalls, 2); // Side effects are not called
    });

    testWidgets(
        'gone watchEffect() without .unwatchEffect() is automatically removed after a watch*()-related rebuild',
        (tester) async {
      final notifier = ValueNotifier(Object());
      var effectCalls = 0;
      final shouldWatchEffect = ValueNotifier(true);
      final (widget, rebuilds) = _widget(
        (context) {
          if (shouldWatchEffect.watch(context)) {
            notifier.watchEffect(context, (_) => effectCalls++);
          }
          return const SizedBox.shrink();
        },
      );

      await tester.pumpWidget(widget);
      expect(rebuilds.value, 1);
      expect(effectCalls, 0);

      shouldWatchEffect.value = false; // Disable watchEffect()
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 2); // Rebuild due to changed shouldWatchEffect

      notifier.value = Object(); // Trigger effect
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 2); // No rebuild
      expect(effectCalls, 0); // No effect calls
    });

    testWidgets(
        'gone watchEffect() without .unwatchEffect() is automatically removed after a non-watch*()-related rebuild as long as other watch*() calls are present',
        (tester) async {
      final notifier = ValueNotifier(Object());
      var effectCalls = 0;
      var shouldWatchEffect = true;
      final changeNotifier = ChangeNotifier();
      final (widget, rebuilds) = _widget(
        (context) {
          _Inherited.of(context);
          changeNotifier.watch(context);
          if (shouldWatchEffect) {
            notifier.watchEffect(context, (_) => effectCalls++);
          }
          return const SizedBox.shrink();
        },
      );

      await tester.pumpWidget(
        _Inherited(
          value: 0,
          child: widget,
        ),
        duration: const Duration(milliseconds: 100),
      );
      expect(rebuilds.value, 1);
      expect(effectCalls, 0);

      shouldWatchEffect = false; // Disable watchEffect()
      await tester.pumpWidget(
        _Inherited(
          value: 1,
          child: widget,
        ),
        duration: const Duration(milliseconds: 100),
      );
      expect(rebuilds.value, 2); // Rebuild due to _Inherited value change
      expect(effectCalls, 0); // No effect calls

      notifier.value = Object(); // Trigger effect
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 2); // No rebuild
      expect(effectCalls, 0); // Effect is not called since effect disappeared
    });

    testWidgets(
        'gone watchEffect() without .unwatchEffect() is **not** automatically removed after a non-watch*()-related rebuild if no other watch*() calls are present',
        (tester) async {
      final notifier = ValueNotifier(Object());
      var effectCalls = 0;
      var shouldWatchEffect = true;
      final (widget, rebuilds) = _widget(
        (context) {
          _Inherited.of(context);
          if (shouldWatchEffect) {
            notifier.watchEffect(context, (_) => effectCalls++);
          }
          return const SizedBox.shrink();
        },
      );

      await tester.pumpWidget(
        _Inherited(
          value: 0,
          child: widget,
        ),
        duration: const Duration(milliseconds: 100),
      );
      expect(rebuilds.value, 1);
      expect(effectCalls, 0);

      shouldWatchEffect = false; // Disable watchEffect()
      await tester.pumpWidget(
        _Inherited(
          value: 1,
          child: widget,
        ),
        duration: const Duration(milliseconds: 100),
      );
      expect(rebuilds.value, 2); // Rebuild due to _Inherited value change
      expect(effectCalls, 0); // No effect calls

      notifier.value = Object(); // Trigger effect
      await tester.pumpAndSettle(); // Trigger vsync
      expect(rebuilds.value, 2); // No rebuild

      /// That's why writing
      /// ```dart
      /// if (condition) {
      ///   notifier.watchEffect(context, key: 'effect')...
      /// } else {
      ///   notifier.unwatchEffect(context, key: 'effect');
      /// }
      /// ```
      /// is recommended over just
      /// ```dart
      /// if (condition) {
      ///   notifier.watchEffect(context)...
      /// }
      /// ```
      expect(effectCalls, 1); // Effect *is* called
    });

    testWidgets(
        'Removing the last effect on a Listenable from build() does *not* remove the listener immediately, but only when the notifier notifies of a change',
        (tester) async {
      final watchEffect1 = ValueNotifier(true);
      final watchEffect2 = ValueNotifier(true);
      final notifier = _ListenersAwareChangeNotifier();
      var effect1Calls = 0;
      var effect2Calls = 0;
      final (widget, rebuilds) = _widget(
        (context) {
          if (watchEffect1.watch(context)) {
            notifier.watchEffect(context, (_) {
              effect1Calls++;
            });
          }
          if (watchEffect2.watch(context)) {
            notifier.watchEffect(context, (_) {
              effect2Calls++;
            });
          }
          return const SizedBox.shrink();
        },
      );

      await tester.pumpWidget(widget);
      expect(rebuilds.value, 1);
      expect(notifier.listeners, 1);

      notifier.notifyListeners();
      expect(effect1Calls, 1);
      expect(effect2Calls, 1);

      watchEffect1.value = false;
      await tester.pumpAndSettle();
      expect(rebuilds.value, 2);
      expect(notifier.listeners, 1);

      notifier.notifyListeners();
      expect(effect1Calls, 1);
      expect(effect2Calls, 2);

      watchEffect2.value = false;
      await tester.pumpAndSettle();
      expect(rebuilds.value, 3);
      // All watch*() calls on the notifier were removed, but the listener stays
      // registered until either the notifier notifies of a change or the
      // context is disposed.
      expect(notifier.listeners, 1);

      notifier.notifyListeners();
      expect(effect1Calls, 1);
      expect(effect2Calls, 2);
      expect(notifier.listeners, 0); // Listener is now gone
    });
  });

  group(
    'keyed watchEffect() modifiers',
    () {
      testWidgets(
        'watchEffect(immediate: true) calls the effect immediately',
        (tester) async {
          final notifier = ValueNotifier(0);
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (value) {
                effectCalls++;
              }, key: 'effect', immediate: true);
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          // Effect is called even though the [notifier] didn't notify of a change
          expect(effectCalls, 1);
        },
      );

      testWidgets(
        'watchEffect(immediate: true) -> watchEffect(immediate: false) -> watchEffect(immediate: true) does_not trigger the effect immediately twice',
        (tester) async {
          final immediate = ValueNotifier(true);
          final notifier = ValueNotifier(0);
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (value) {
                effectCalls++;
              }, key: 'effect', immediate: immediate.watch(context));
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          expect(effectCalls, 1);

          immediate.value = false;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 2);
          expect(effectCalls, 1); // Effect is not called again immediately

          immediate.value = true;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 3);
          expect(effectCalls, 1); // Effect is not called again immediately
        },
      );

      testWidgets(
        'watchEffect(once: true) calls the effect only once',
        (tester) async {
          final notifier = ValueNotifier(0);
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (value) {
                effectCalls++;
              }, key: 'effect', once: true);
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          expect(effectCalls, 0);

          notifier.value = 1;
          expect(effectCalls, 1);

          notifier.value = 2;
          expect(effectCalls, 1);

          await tester.pumpAndSettle();
          notifier.value = 3;
          expect(effectCalls, 1);
        },
      );

      testWidgets(
        'watchEffect(once: true) -> watchEffect(once: false) allows for the effect to be called again',
        (tester) async {
          final once = ValueNotifier(true);
          final notifier = ValueNotifier(0);
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (value) {
                effectCalls++;
              }, key: 'effect', once: once.watch(context));
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          expect(effectCalls, 0);

          notifier.value = 1;
          expect(effectCalls, 1);

          notifier.value = 2;
          expect(effectCalls, 1);

          once.value = false;
          await tester.pumpAndSettle();
          notifier.value = 3;
          // Effect is called again since [once] is false now
          expect(effectCalls, 2);

          once.value = true;
          await tester.pumpAndSettle();
          notifier.value = 4;
          // Effect is not called again since [once] is true again
          expect(effectCalls, 2);
        },
      );

      testWidgets(
        'watchEffect(immediate: true, once: true) calls the effect only once, immediately',
        (tester) async {
          final notifier = ValueNotifier(0);
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (value) {
                effectCalls++;
              }, key: 'effect', immediate: true, once: true);
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          // Effect is called even though the [notifier] didn't notify of a change
          expect(effectCalls, 1);

          notifier.value = 1;
          expect(effectCalls, 1);

          notifier.value = 2;
          expect(effectCalls, 1);

          await tester.pumpAndSettle();
          notifier.value = 3;
          expect(effectCalls, 1);
        },
      );

      testWidgets(
        'watchEffect(key: 1) -> watchEffect(key: 2) -> watchEffect(key: 1) keeps the state of the first key',
        (tester) async {
          final useEffect1 = ValueNotifier(true);
          final notifier = ValueNotifier(0);
          var effect1Calls = 0;
          var effect2Calls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              if (useEffect1.watch(context)) {
                notifier.watchEffect(context, (value) {
                  effect1Calls++;
                }, key: 1, immediate: true);
              } else {
                notifier.watchEffect(context, (value) {
                  effect2Calls++;
                }, key: 2);
              }
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          // immediate effect
          expect(effect1Calls, 1);
          expect(effect2Calls, 0);

          useEffect1.value = false;
          await tester.pumpAndSettle();
          expect(effect1Calls, 1);
          // effect #2 is not called since it's not immediate
          expect(effect2Calls, 0);

          notifier.value = 1;
          // effect #1 is not called since it's unwatched
          expect(effect1Calls, 1);
          // effect #2 is called due to the change notification
          expect(effect2Calls, 1);

          useEffect1.value = true;
          await tester.pumpAndSettle();
          // effect #1 is not called again immediately since it was called
          // once already
          expect(effect1Calls, 1);
          // effect #2 is not called again since it's unwatched
          expect(effect2Calls, 1);
        },
      );
    },
  );

  group(
    'watchEffect() and watchOnly() interop',
    () {
      testWidgets(
        'watchEffect() and watchOnly() can be used together',
        (tester) async {
          final notifier = ValueNotifier(0);
          var watchOnlyResult = 0;
          var watchOnlyCalls = 0;
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (_) => effectCalls++);
              notifier.watchOnly(context, (_) {
                watchOnlyCalls++;
                return watchOnlyResult;
              });
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          expect(watchOnlyCalls, 1);
          expect(effectCalls, 0);

          notifier.value = 1;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 1); // No rebuild
          expect(watchOnlyCalls, 2); // .watchOnly() callback was called again
          expect(effectCalls, 1); // .watchEffect() callback was called

          notifier.value = 2;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 1); // No rebuild
          expect(watchOnlyCalls, 3); // .watchOnly() callback was called again
          expect(effectCalls, 2); // .watchEffect() callback was called again

          watchOnlyResult = 1;
          notifier.value = 3;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 2); // Rebuild, .watchOnly() result changed
          // .watchOnly() callback was called on both the notification and
          // during the resulting build() method call
          expect(watchOnlyCalls, 5);
          expect(effectCalls, 3); // .watchEffect() callback was called again
        },
      );
      testWidgets(
        'watchEffect(immediate: true) and watchOnly() can be used together',
        (tester) async {
          final notifier = ValueNotifier(0);
          var watchOnlyResult = 0;
          var watchOnlyCalls = 0;
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (_) {
                effectCalls++;
              }, immediate: true, key: 'effect');
              notifier.watchOnly(context, (_) {
                watchOnlyCalls++;
                return watchOnlyResult;
              });
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          // .watchOnly() callback was called during the initial build
          expect(watchOnlyCalls, 1);
          // .watchEffect(immediate: true) callback was called
          expect(effectCalls, 1);

          notifier.value = 1;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 1); // No rebuild
          // .watchOnly() callback was called again due to notification
          expect(watchOnlyCalls, 2);
          // .watchEffect() callback was called again due to notification
          expect(effectCalls, 2);

          watchOnlyResult = 1;
          notifier.value = 2;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 2); // Rebuild, .watchOnly() result changed
          // .watchOnly() callback was called on both the notification and
          // during the resulting build() method call
          expect(watchOnlyCalls, 4);
          // .watchEffect() callback was called again due to notification
          expect(effectCalls, 3);
        },
      );
      testWidgets(
        'watchEffect(immediate: true, once: true) and watchOnly() can be used together',
        (tester) async {
          final notifier = ValueNotifier(0);
          var watchOnlyResult = 0;
          var watchOnlyCalls = 0;
          var effectCalls = 0;
          final (widget, rebuilds) = _widget(
            (context) {
              notifier.watchEffect(context, (_) {
                effectCalls++;
              }, immediate: true, once: true, key: 'effect');
              notifier.watchOnly(context, (_) {
                watchOnlyCalls++;
                return watchOnlyResult;
              });
              return const SizedBox.shrink();
            },
          );

          await tester.pumpWidget(widget);
          expect(rebuilds.value, 1);
          // .watchOnly() callback was called during the initial build
          expect(watchOnlyCalls, 1);
          // .watchEffect(immediate: true, once: true) callback was called
          expect(effectCalls, 1);

          notifier.value = 1;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 1); // No rebuild
          // .watchOnly() callback was called again due to notification
          expect(watchOnlyCalls, 2);
          // No more .watchEffect() callbacks since [once] is true
          expect(effectCalls, 1);

          watchOnlyResult = 1;
          notifier.value = 2;
          await tester.pumpAndSettle();
          expect(rebuilds.value, 2); // Rebuild, .watchOnly() result changed
          // .watchOnly() callback was called on both the notification and
          // during the resulting build() method call
          expect(watchOnlyCalls, 4);
          // No more .watchEffect() callbacks since [once] is true
          expect(effectCalls, 1);
        },
      );
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

class _Inherited extends InheritedWidget {
  const _Inherited({
    required this.value,
    required super.child,
  });

  final Object value;

  static _Inherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Inherited>()!;

  @override
  bool updateShouldNotify(_Inherited oldWidget) => value != oldWidget.value;
}

class _ListenersAwareChangeNotifier extends ChangeNotifier {
  int _listeners = 0;

  int get listeners => _listeners;

  @override
  void addListener(VoidCallback listener) {
    _listeners++;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners--;
    super.removeListener(listener);
  }
}
