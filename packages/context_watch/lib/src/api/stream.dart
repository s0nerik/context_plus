import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

import '../watchers/stream_context_watcher.dart';

extension StreamContextWatchExtension<T> on Stream<T> {
  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// If this [Stream] is a [ValueStream], the initial value will be used
  /// as the initial value of the [AsyncSnapshot].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    final observable = InheritedContextWatch.of(
      context,
    ).getOrCreateObservable<T>(
      context,
      this,
      ContextWatcherObservableType.stream,
    );

    observable.watch();

    final subscription =
        observable.subscription as ContextWatchStreamSubscription;
    return subscription.snapshot as AsyncSnapshot<T>;
  }

  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// If this [Stream] is a [ValueStream], the initial value will be used
  /// as the initial value of the [AsyncSnapshot].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> snapshot) selector,
  ) {
    final observable = InheritedContextWatch.of(
      context,
    ).getOrCreateObservable<T>(
      context,
      this,
      ContextWatcherObservableType.stream,
    );

    final subscription =
        observable.subscription as ContextWatchStreamSubscription;
    final selectedValue = selector(subscription.snapshot as AsyncSnapshot<T>);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }

  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [effect] will be called,
  /// *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   stream.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   stream.unwatchEffect(context, key: 'effect');
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
        .getOrCreateObservable<T>(
          context,
          this,
          ContextWatcherObservableType.stream,
        )
        .watchEffect(effect, key: key, immediate: immediate, once: once);
  }

  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Stream] notifies of a change.
  void unwatchEffect(BuildContext context, {required Object key}) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
