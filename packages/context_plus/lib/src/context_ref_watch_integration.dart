import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension RefContextWatchExt<T> on Ref<T> {
  /// Get the value of this [Ref] from the given [context].
  T of(BuildContext context) {
    context.unwatch();
    return ContextRefExt(this).of(context);
  }
}

extension RefListenableContextWatchExtension<TListenable extends Listenable>
    on Ref<TListenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  ///
  /// Returns the original [Listenable].
  TListenable watchListenable(BuildContext context) =>
      of(context).watchListenable(context);
}

extension RefListenableContextWatchValueExtension<
    TListenable extends Listenable> on Ref<TListenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchListenableValue<R>(
    BuildContext context,
    R Function(TListenable listenable) selector,
  ) =>
      of(context).watchListenableValue(context, selector);
}

extension RefValueListenableWatchExt<T> on Ref<ValueListenable<T>> {
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

extension RefValueListenableWatchValueExt<T> on Ref<ValueListenable<T>> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchValue<R>(BuildContext context, R Function(T value) selector) =>
      of(context).watchValue(context, selector);
}

extension RefFutureWatchExt<T> on Ref<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension RefFutureWatchValueExt<T> on Ref<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// Returns the value returned by [selector].
  ///
  /// When this [Future] completes, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchValue<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchValue(context, selector);
}

extension RefStreamWatchExt<T> on Ref<Stream<T>> {
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

extension RefStreamWatchValueExt<T> on Ref<Stream<T>> {
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
  R watchValue<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchValue(context, selector);
}
