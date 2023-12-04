import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

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

  final _contextFutureSubscriptions =
      HashMap<BuildContext, HashMap<Future, FutureSubscription>>.identity();

  final snapshots = HashMap<FutureSubscription, AsyncSnapshot>.identity();

  @override
  FutureSubscription watch<T>(
    BuildContext context,
    Future observable,
  ) {
    final element = context as Element;
    final subscriptions =
        _contextFutureSubscriptions[context] ??= HashMap.identity();

    final existingSubscription = subscriptions[observable];
    if (existingSubscription != null) {
      return existingSubscription;
    }

    final subscription = subscriptions[observable] = FutureSubscription();
    snapshots[subscription] = AsyncSnapshot<T>.nothing();
    observable.then((data) {
      if (!canNotify(context, observable)) {
        return;
      }
      if (subscription.isCanceled) {
        return;
      }
      snapshots[subscription] =
          AsyncSnapshot<T>.withData(ConnectionState.done, data);
      element.markNeedsBuild();
    }, onError: (Object error, StackTrace stackTrace) {
      if (!canNotify(context, observable)) {
        return;
      }
      if (subscription.isCanceled) {
        return;
      }
      snapshots[subscription] =
          AsyncSnapshot<T>.withError(ConnectionState.done, error, stackTrace);
      element.markNeedsBuild();
    });
    // An implementation like `SynchronousFuture` may have already called the
    // .then closure. Do not overwrite it in that case.
    if (snapshots[subscription]!.connectionState != ConnectionState.done) {
      snapshots[subscription] =
          snapshots[subscription]!.inState(ConnectionState.waiting);
    }

    return subscription;
  }

  @override
  void unwatch(
    BuildContext context,
    Future observable,
  ) {
    final subscription =
        _contextFutureSubscriptions[context]?.remove(observable);
    if (subscription == null) {
      return;
    }
    subscription.isCanceled = true;
    snapshots.remove(subscription);
  }

  @override
  void unwatchContext(BuildContext context) {
    final subscriptions = _contextFutureSubscriptions.remove(context);
    if (subscriptions == null) {
      return;
    }
    for (final subscription in subscriptions.values) {
      subscription.isCanceled = true;
      snapshots.remove(subscription);
    }
  }

  @override
  void unwatchAllContexts() {
    for (final subscriptions in _contextFutureSubscriptions.values) {
      for (final subscription in subscriptions.values) {
        subscription.isCanceled = true;
        snapshots.remove(subscription);
      }
    }
    _contextFutureSubscriptions.clear();
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

    context.dependOnInheritedWidgetOfExactType<InheritedFutureContextWatch>();
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedFutureContextWatch>() as InheritedFutureContextWatchElement;
    final subscription = watchRoot.subscribe<T>(context, this);
    if (subscription == null) {
      return AsyncSnapshot<T>.nothing();
    }
    return watchRoot.snapshots[subscription] as AsyncSnapshot<T>;
  }
}
