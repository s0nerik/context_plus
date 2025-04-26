import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension ListenableContextWatchExtension<TListenable extends Listenable>
    on TListenable {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  TListenable watch(BuildContext context) {
    InheritedContextWatch.of(
      context,
    ).getOrCreateObservable(context, this)?.watch();
    return this;
  }

  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable listenable) selector,
  ) {
    final observable = InheritedContextWatch.of(
      context,
    ).getOrCreateObservable(context, this);
    if (observable == null) return selector(this);

    final selectedValue = selector(this);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }

  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [effect] will be
  /// called, *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   listenable.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   listenable.unwatchEffect(context, key: 'effect');
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
    void Function(TListenable listenable) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }

  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Listenable] notifies of a change.
  void unwatchEffect(BuildContext context, {required Object key}) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}

extension ValueListenableContextWatchExtension<
  TListenable extends ValueListenable<T>,
  T
>
    on TListenable {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current value of the [ValueListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    InheritedContextWatch.of(
      context,
    ).getOrCreateObservable<T>(context, this)?.watch();
    return value;
  }

  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final observable = InheritedContextWatch.of(
      context,
    ).getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(value);

    final selectedValue = selector(value);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }

  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [effect] will be
  /// called, *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   listenable.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   listenable.unwatchEffect(context, key: 'effect');
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
    void Function(T value) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }
}
