import 'package:async_listenable/async_listenable.dart';
import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension ReadOnlyRefListenableWatchAPI<TListenable extends Listenable>
    on context_ref.ReadOnlyRef<TListenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// Returns the current [Listenable] object.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  TListenable watch(BuildContext context) => of(context).watch(context);
}

extension ReadOnlyRefListenableWatchOnlyAPI<TListenable extends Listenable>
    on context_ref.ReadOnlyRef<TListenable> {
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
  ) =>
      of(context).watchOnly(context, selector);
}

extension ReadOnlyRefListenableWatchEffectAPI<TListenable extends Listenable>
    on context_ref.ReadOnlyRef<TListenable> {
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
  ///   _listenable.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   _listenable.unwatchEffect(context, key: 'effect');
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
  }) =>
      of(context).watchEffect(context, effect,
          key: key, immediate: immediate, once: once);
}

extension ReadOnlyRefListenableUnwatchEffectAPI
    on context_ref.ReadOnlyRef<Listenable> {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Listenable] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) =>
      of(context).unwatchEffect(context, key: key);
}

extension ReadOnlyRefValueListenableWatchAPI<T>
    on context_ref.ReadOnlyRef<ValueListenable<T>> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current value of the [ValueListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watchValue(BuildContext context) => of(context).watchValue(context);
}

extension ReadOnlyRefAsyncListenableWatchAPI<T>
    on context_ref.ReadOnlyRef<AsyncListenable<T>> {
  /// Watch this [AsyncListenable] for changes.
  ///
  /// Whenever this [AsyncListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current [AsyncSnapshot] of the [AsyncListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watchValue(BuildContext context) =>
      of(context).watchValue(context);
}

extension ReadOnlyRefFutureWatchAPI<T> on context_ref.ReadOnlyRef<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension ReadOnlyRefFutureWatchOnlyAPI<T>
    on context_ref.ReadOnlyRef<Future<T>> {
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
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchOnly(context, selector);
}

extension ReadOnlyRefFutureWatchEffectAPI<T>
    on context_ref.ReadOnlyRef<Future<T>> {
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
  ///   _future.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   _future.unwatchEffect(context, key: 'effect');
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
  }) =>
      of(context).watchEffect(context, effect,
          key: key, immediate: immediate, once: once);
}

extension ReadOnlyRefFutureUnwatchEffectAPI on context_ref.ReadOnlyRef<Future> {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Future] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) =>
      of(context).unwatchEffect(context, key: key);
}

extension ReadOnlyRefStreamWatchAPI<T> on context_ref.ReadOnlyRef<Stream<T>> {
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
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension ReadOnlyRefStreamWatchOnlyAPI<T>
    on context_ref.ReadOnlyRef<Stream<T>> {
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
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchOnly(context, selector);
}

extension ReadOnlyRefStreamWatchEffectAPI<T>
    on context_ref.ReadOnlyRef<Stream<T>> {
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
  ///   _stream.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   _stream.unwatchEffect(context, key: 'effect');
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
  }) =>
      of(context).watchEffect(context, effect,
          key: key, immediate: immediate, once: once);
}

extension ReadOnlyRefStreamUnwatchEffectAPI on context_ref.ReadOnlyRef<Stream> {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Stream] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) =>
      of(context).unwatchEffect(context, key: key);
}
