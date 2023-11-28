import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

import 'async_snapshot_converter.dart';
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

  final watchersCount = HashMap<Stream, int>();
  final streamToBroadcastStream = HashMap<Stream, Stream>();
  final snapshots = HashMap<StreamSubscription, AsyncSnapshot>();

  @override
  StreamSubscription watch(
    BuildContext context,
    Stream observable,
    void Function() callback,
  ) {
    watchersCount[observable] = (watchersCount[observable] ?? 0) + 1;

    final stream =
        streamToBroadcastStream[observable] ??= observable.asBroadcastStream();

    late final StreamSubscription subscription;
    subscription = stream.listen((data) {
      snapshots[subscription] =
          AsyncSnapshot.withData(ConnectionState.active, data);
      callback();
    }, onError: (error, trace) {
      if (trace != null) {
        snapshots[subscription] =
            AsyncSnapshot.withError(ConnectionState.active, error, trace);
      } else {
        snapshots[subscription] =
            AsyncSnapshot.withError(ConnectionState.active, error);
      }
      callback();
    }, onDone: () {
      final data = snapshots[subscription]!.data;
      if (data != null) {
        snapshots[subscription] =
            AsyncSnapshot.withData(ConnectionState.done, data);
      } else {
        snapshots[subscription] =
            const AsyncSnapshot.nothing().inState(ConnectionState.done);
      }
      callback();
    });
    return subscription;
  }

  @override
  void unwatch(
    BuildContext context,
    Stream observable,
    StreamSubscription subscription,
  ) {
    watchersCount[observable] = (watchersCount[observable] ?? 0) - 1;
    if (watchersCount[observable]! <= 0) {
      streamToBroadcastStream.remove(observable);
      watchersCount.remove(observable);
    }
    snapshots.remove(subscription);
    subscription.cancel();
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

    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: this,
    );

    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedStreamContextWatch>() as InheritedStreamContextWatchElement;

    final subscription =
        watchRoot.getElementSubscription(context as Element, this);
    final snapshot = watchRoot.snapshots[subscription];
    return convertAsyncSnapshot(snapshot);
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
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: this,
    );

    final watchRoot = context.getElementForInheritedWidgetOfExactType<
        InheritedStreamContextWatch>() as InheritedStreamContextWatchElement;

    final subscription =
        watchRoot.getElementSubscription(context as Element, this);
    final snapshot = watchRoot.snapshots[subscription];
    if (snapshot == null) {
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
    return convertAsyncSnapshot(snapshot);
  }
}
