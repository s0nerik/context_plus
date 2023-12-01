import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'async_snapshot_generator.dart';
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

  final snapshotGenerator = AsyncSnapshotGenerator<FutureSubscription>();

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
      if (!canNotify(context, observable)) {
        return;
      }
      snapshotGenerator.setConnectionState(subscription, ConnectionState.done);
      snapshotGenerator.setData(subscription, data);
      callback();
    }, onError: (error, trace) {
      if (subscription.isCanceled) {
        return;
      }
      if (!canNotify(context, observable)) {
        return;
      }
      snapshotGenerator.setConnectionState(subscription, ConnectionState.done);
      snapshotGenerator.setError(subscription, error, trace);
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
    snapshotGenerator.clear(subscription);
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

    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedFutureContextWatch>() as InheritedFutureContextWatchElement;
    final subscription = watchRoot.subscribe(context as Element, this);
    return watchRoot.snapshotGenerator.generate(subscription);
  }
}
