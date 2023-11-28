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

  final watchersCount = HashMap<Stream, int>();
  final streamToBroadcastStream = HashMap<Stream, Stream>();

  final asyncSnapshotGenerator = AsyncSnapshotGenerator<StreamSubscription>();

  @override
  StreamSubscription watch(
    BuildContext context,
    Stream observable,
    void Function() callback,
  ) {
    watchersCount[observable] = (watchersCount[observable] ?? 0) + 1;

    final stream = streamToBroadcastStream[observable] ??=
        observable.isBroadcast ? observable : observable.asBroadcastStream();

    late final StreamSubscription subscription;
    subscription = stream.listen((data) {
      asyncSnapshotGenerator.setConnectionState(
          subscription, ConnectionState.active);
      asyncSnapshotGenerator.setData(subscription, data);
      callback();
    }, onError: (error, trace) {
      asyncSnapshotGenerator.setConnectionState(
          subscription, ConnectionState.active);
      asyncSnapshotGenerator.setError(subscription, error, trace);
      callback();
    }, onDone: () {
      asyncSnapshotGenerator.setConnectionState(
          subscription, ConnectionState.done);
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
    asyncSnapshotGenerator.clear(subscription);
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

    final subscription = watchRoot.getSubscription(context, this);
    return watchRoot.asyncSnapshotGenerator.buildAsyncSnapshot(subscription);
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

    final subscription = watchRoot.getSubscription(context, this);
    final connectionState =
        watchRoot.asyncSnapshotGenerator.getConnectionState(subscription);
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
    return watchRoot.asyncSnapshotGenerator.buildAsyncSnapshot(subscription);
  }
}
