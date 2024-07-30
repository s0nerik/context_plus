import 'package:async_listenable/async_listenable.dart';
import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension ReadOnlyRefListenableWatchAPI on context_ref.ReadOnlyRef<Listenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) => of(context).watch(context);
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
  T watch(BuildContext context) => of(context).watch(context);
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
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
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
