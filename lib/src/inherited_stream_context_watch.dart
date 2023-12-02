import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

import 'async_snapshot_generator.dart';
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

  final snapshotGenerator = AsyncSnapshotGenerator<StreamSubscription>();

  @override
  StreamSubscription watch(
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
      snapshotGenerator.setConnectionState(
          subscription, ConnectionState.active);
      snapshotGenerator.setData(subscription, data);
      element.markNeedsBuild();
    }, onError: (error, trace) {
      if (!canNotify(context, observable)) {
        return;
      }
      snapshotGenerator.setConnectionState(
          subscription, ConnectionState.active);
      snapshotGenerator.setError(subscription, error, trace);
      element.markNeedsBuild();
    }, onDone: () {
      if (!canNotify(context, observable)) {
        return;
      }
      snapshotGenerator.setConnectionState(subscription, ConnectionState.done);
      element.markNeedsBuild();
    });
    return subscription;
  }

  @override
  void unwatch(
    BuildContext context,
    Stream observable,
    StreamSubscription subscription,
  ) {
    snapshotGenerator.clear(subscription);
    subscription.cancel();
    _contextStreamSubscriptions[context]?.remove(observable);
  }
}

extension StreamContextWatchExtension<T> on Stream<T> {
  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    if (this is ValueStream<T>) {
      return (this as ValueStream<T>).watch(context);
    }

    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>();
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedStreamContextWatch>() as InheritedStreamContextWatchElement;
    final subscription = watchRoot.subscribe(context, this);
    return watchRoot.snapshotGenerator.generate(subscription);
  }
}

extension ValueStreamContextWatchExtension<T> on ValueStream<T> {
  /// Watch this [ValueStream] for changes.
  ///
  /// Whenever this [ValueStream] emits new value (except for initial value),
  /// the [context] will be rebuilt.
  ///
  /// Returns the current value of the [ValueStream].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>();
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedStreamContextWatch>() as InheritedStreamContextWatchElement;
    final subscription = watchRoot.subscribe(context as Element, this);
    final connectionState =
        watchRoot.snapshotGenerator.getConnectionState(subscription);
    if (connectionState == null) {
      if (hasValue) {
        return AsyncSnapshot<T>.withData(ConnectionState.waiting, value);
      }
      if (hasError) {
        if (stackTrace != null) {
          return AsyncSnapshot<T>.withError(
            ConnectionState.waiting,
            error,
            stackTrace!,
          );
        }
        return AsyncSnapshot<T>.withError(
          ConnectionState.waiting,
          error,
        );
      }
    }
    return watchRoot.snapshotGenerator.generate(subscription);
  }
}
