// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class _FutureSubscription implements ContextWatchSubscription {
  _FutureSubscription({
    required this.snapshot,
  });

  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;

  AsyncSnapshot snapshot;

  @override
  get callbackArgument => snapshot;

  @override
  void cancel() => _isCanceled = true;
}

@internal
class FutureContextWatcher extends ContextWatcher<Future> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Future observable,
  ) {
    final subscription = _FutureSubscription(
      snapshot: AsyncSnapshot<T>.nothing(),
    );
    observable.then((data) {
      if (subscription.isCanceled) {
        return;
      }

      final newSnapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, observable);
    }, onError: (Object error, StackTrace stackTrace) {
      if (subscription.isCanceled) {
        return;
      }

      final newSnapshot =
          AsyncSnapshot<T>.withError(ConnectionState.done, error, stackTrace);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, observable);
    });
    // An implementation like `SynchronousFuture` may have already called the
    // .then closure. Do not overwrite it in that case.
    if (subscription.snapshot.connectionState != ConnectionState.done) {
      subscription.snapshot =
          subscription.snapshot.inState(ConnectionState.waiting);
    }

    return subscription;
  }
}

extension FutureContextWatchExtension<T> on Future<T> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return AsyncSnapshot<T>.nothing();

    observable.watch();

    final subscription = observable.subscription as _FutureSubscription;
    return subscription.snapshot as AsyncSnapshot<T>;
  }
}

extension FutureContextWatchOnlyExtension<T> on Future<T> {
  /// Watch this [Future] for changes.
  ///
  /// Returns the value returned by [selector].
  ///
  /// When this [Future] completes, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> snapshot) selector,
  ) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(AsyncSnapshot<T>.nothing());

    final subscription = observable.subscription as _FutureSubscription;
    final selectedValue = selector(subscription.snapshot as AsyncSnapshot<T>);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }
}

extension FutureContextWatchEffectExtension<T> on Future<T> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [effect] will be called, *without*
  /// rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   future.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   future.unwatchEffect(context, key: 'effect');
  /// }
  /// ```
  ///
  /// If [immediate] is `true`, the effect will be called upon effect
  /// registration immediately. If [once] is `true`, the effect will be called
  /// only once. These parameters can be combined.
  ///
  /// [immediate] and [once] parameters require a unique [key].
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T> snapshot) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }
}

extension FutureContextUnwatchEffectExtension on Future {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Future] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
