import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedStreamContextWatch
    extends InheritedContextWatch<Stream, StreamSubscription> {
  const InheritedStreamContextWatch({
    super.key,
    required super.child,
  });

  @override
  ObservableNotifierInheritedElement<Stream, StreamSubscription>
      createElement() => InheritedStreamContextWatchElement(this);
}

@internal
class InheritedStreamContextWatchElement
    extends ObservableNotifierInheritedElement<Stream, StreamSubscription> {
  InheritedStreamContextWatchElement(super.widget);

  final _contextStreamSubscriptions =
      HashMap<BuildContext, HashMap<Stream, StreamSubscription>>.identity();

  final snapshots = HashMap<StreamSubscription, AsyncSnapshot>.identity();

  @override
  StreamSubscription watch<T>(
    BuildContext context,
    Stream observable,
  ) {
    final element = context as Element;
    final subscriptions =
        _contextStreamSubscriptions[context] ??= HashMap.identity();

    final existingSubscription = subscriptions[observable];
    if (existingSubscription != null) {
      return existingSubscription;
    }

    late final StreamSubscription subscription;
    subscription = subscriptions[observable] = observable.listen((data) {
      if (!canNotify(context, observable)) {
        return;
      }
      snapshots[subscription] =
          AsyncSnapshot<T>.withData(ConnectionState.active, data);
      element.markNeedsBuild();
    }, onError: (Object error, StackTrace stackTrace) {
      if (!canNotify(context, observable)) {
        return;
      }
      snapshots[subscription] =
          AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);
      element.markNeedsBuild();
    }, onDone: () {
      if (!canNotify(context, observable)) {
        return;
      }
      snapshots[subscription] = (snapshots[subscription]! as AsyncSnapshot<T>)
          .inState(ConnectionState.done);
      element.markNeedsBuild();
    });

    if (observable is ValueStream<T>) {
      if (observable.hasValue) {
        snapshots[subscription] = AsyncSnapshot<T>.withData(
          ConnectionState.waiting,
          observable.value,
        );
      } else if (observable.hasError) {
        if (observable.stackTrace != null) {
          snapshots[subscription] = AsyncSnapshot<T>.withError(
            ConnectionState.waiting,
            observable.error,
            observable.stackTrace!,
          );
        }
        snapshots[subscription] = AsyncSnapshot<T>.withError(
          ConnectionState.waiting,
          observable.error,
        );
      } else {
        snapshots[subscription] =
            AsyncSnapshot<T>.nothing().inState(ConnectionState.waiting);
      }
    } else {
      snapshots[subscription] =
          AsyncSnapshot<T>.nothing().inState(ConnectionState.waiting);
    }

    return subscription;
  }

  @override
  void unwatch(
    BuildContext context,
    Stream observable,
  ) {
    final subscription =
        _contextStreamSubscriptions[context]?.remove(observable);
    if (subscription == null) {
      return;
    }
    snapshots.remove(subscription);
    subscription.cancel();
  }

  @override
  void unwatchContext(BuildContext context) {
    final subscriptions = _contextStreamSubscriptions.remove(context);
    if (subscriptions == null) {
      return;
    }
    for (final subscription in subscriptions.values) {
      snapshots.remove(subscription);
      subscription.cancel();
    }
  }

  @override
  void unwatchAllContexts() {
    for (final subscriptions in _contextStreamSubscriptions.values) {
      for (final subscription in subscriptions.values) {
        snapshots.remove(subscription);
        subscription.cancel();
      }
    }
    _contextStreamSubscriptions.clear();
  }
}

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
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>();
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedStreamContextWatch>() as InheritedStreamContextWatchElement;
    final subscription = watchRoot.subscribe<T>(context, this);
    if (subscription == null) {
      return AsyncSnapshot<T>.nothing();
    }
    return watchRoot.snapshots[subscription] as AsyncSnapshot<T>;
  }
}
