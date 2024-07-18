import 'package:async_listenable/async_listenable.dart';
import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension RefAPI<T> on context_ref.Ref<T> {
  /// Bind a value to this [Ref] for this and all descendant [BuildContext]s.
  ///
  /// [create] is called only once per [BuildContext] and the value remains
  /// alive until the [BuildContext] is removed from the tree.
  ///
  /// [dispose] is called when the [BuildContext] is removed from the tree.
  /// If [dispose] is not specified, the provided value will be disposed by
  /// via `value.dispose()` if such method exists. Use [bindValue] if you don't
  /// want the value to be disposed automatically.
  ///
  /// [key] is used to identify the value. If [key] changes, the old value
  /// will be disposed and a new value will be created.
  T bind(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
    Object? key,
  }) {
    context.unwatch();
    return context_ref.RefAPI(this)
        .bind(context, create, dispose: dispose, key: key);
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the value
  /// is requested for the first.
  void bindLazy(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
    Object? key,
  }) {
    context.unwatch();
    context_ref.RefAPI(this)
        .bindLazy(context, create, dispose: dispose, key: key);
  }

  /// Bind a value to this [Ref] for this and all descendant [BuildContext]s.
  ///
  /// [value] is used as the value of this [Ref]. If [value] changes, all
  /// widgets that depend on this [Ref] will be rebuilt.
  ///
  /// This method doesn't manage the lifecycle of the value. It is up to the
  /// caller to dispose the value when it is no longer needed.
  ///
  /// Use [bind] if you want the value to be disposed automatically.
  T bindValue(
    BuildContext context,
    T value,
  ) {
    context.unwatch();
    return context_ref.RefAPI(this).bindValue(context, value);
  }
}

extension ReadOnlyRefAPI<T> on context_ref.ReadOnlyRef<T> {
  /// Get the value of this [Ref] from the given [context].
  T of(BuildContext context) {
    context.unwatch();
    return context_ref.ReadOnlyRefAPI(this).of(context);
  }
}

extension ReadOnlyRefListenableWatchAPI on context_ref.ReadOnlyRef<Listenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) =>
      ReadOnlyRefAPI(this).of(context).watch(context);
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
      ReadOnlyRefAPI(this).of(context).watchOnly(context, selector);
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
  T watch(BuildContext context) =>
      ReadOnlyRefAPI(this).of(context).watch(context);
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
  AsyncSnapshot<T> watch(BuildContext context) =>
      ReadOnlyRefAPI(this).of(context).watch(context);
}

extension ReadOnlyRefFutureWatchAPI<T> on context_ref.ReadOnlyRef<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) =>
      ReadOnlyRefAPI(this).of(context).watch(context);
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
      ReadOnlyRefAPI(this).of(context).watchOnly(context, selector);
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
  AsyncSnapshot<T> watch(BuildContext context) =>
      ReadOnlyRefAPI(this).of(context).watch(context);
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
      ReadOnlyRefAPI(this).of(context).watchOnly(context, selector);
}
