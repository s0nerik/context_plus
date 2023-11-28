import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'async_snapshot_converter.dart';
import 'inherited_context_watch.dart';

@internal
class FutureSubscription {
  FutureSubscription();

  bool isCanceled = false;
}

@internal
class InheritedFutureContextWatch
    extends InheritedContextWatch<Future, FutureSubscription> {
  const InheritedFutureContextWatch({
    super.key,
    required super.child,
  });

  @override
  ObservableNotifierInheritedElement<Future, FutureSubscription>
      createElement() => InheritedFutureContextWatchElement(this);
}

@internal
class InheritedFutureContextWatchElement
    extends ObservableNotifierInheritedElement<Future, FutureSubscription> {
  InheritedFutureContextWatchElement(super.widget);

  final snapshots = HashMap<FutureSubscription, AsyncSnapshot>();

  @override
  FutureSubscription watch(
    BuildContext context,
    Future observable,
    void Function() callback,
  ) {
    final subscription = FutureSubscription();

    observable.then((data) {
      if (subscription.isCanceled) {
        return;
      }
      snapshots[subscription] =
          AsyncSnapshot.withData(ConnectionState.done, data);
      callback();
    }, onError: (error, trace) {
      if (subscription.isCanceled) {
        return;
      }
      if (trace != null) {
        snapshots[subscription] =
            AsyncSnapshot.withError(ConnectionState.done, error, trace);
      } else {
        snapshots[subscription] =
            AsyncSnapshot.withError(ConnectionState.done, error);
      }
      callback();
    });

    return subscription;
  }

  @override
  void unwatch(
    BuildContext context,
    Future observable,
    FutureSubscription subscription,
  ) {
    subscription.isCanceled = true;
    snapshots.remove(subscription);
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
    if (this is SynchronousFuture<T>) {
      late final T result;
      (this as SynchronousFuture<T>).then((value) => result = value);
      return AsyncSnapshot<T>.withData(ConnectionState.done, result);
    }

    context.dependOnInheritedWidgetOfExactType<InheritedFutureContextWatch>(
      aspect: this,
    );

    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedFutureContextWatch>() as InheritedFutureContextWatchElement;

    final subscription =
        watchRoot.getElementSubscription(context as Element, this);
    final snapshot = watchRoot.snapshots[subscription];
    return convertAsyncSnapshot(snapshot);
  }
}

extension FutureOrContextWatchExtension<T extends Object> on FutureOr<T> {
  /// Watch this [FutureOr] for changes.
  ///
  /// When this [FutureOr] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    if (this is Future<T>) {
      return (this as Future<T>).watch(context);
    }
    return AsyncSnapshot<T>.withData(ConnectionState.done, this as T);
  }
}
