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

extension RefListenableWatchExt<TListenable extends Listenable>
    on Ref<TListenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  TListenable watch(BuildContext context) => of(context).watch(context);
}

extension RefValueListenableWatchExt<TListenable extends ValueListenable<T>, T>
    on Ref<TListenable> {
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

extension RefValueListenableWatchForExt<T> on Ref<ValueListenable<T>> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchFor<R>(BuildContext context, R Function(T value) selector) =>
      of(context).watchFor(context, selector);
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

extension RefFutureWatchForExt<T> on Ref<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// Returns the value returned by [selector].
  ///
  /// When this [Future] completes, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchFor<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchFor(context, selector);
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

extension RefStreamWatchForExt<T> on Ref<Stream<T>> {
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
  R watchFor<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> value) selector,
  ) =>
      of(context).watchFor(context, selector);
}
