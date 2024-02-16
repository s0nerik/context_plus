import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/streams.dart';

class _StreamSubscription implements ContextWatchSubscription {
  _StreamSubscription({
    required StreamSubscription<dynamic> streamSubscription,
    required this.snapshot,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;
  AsyncSnapshot snapshot;

  @override
  void cancel() => _sub.cancel();
}

class StreamContextWatcher extends ContextWatcher<Stream> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Stream observable,
  ) {
    final stream = observable as Stream<T>;
    final element = context as Element;

    late final _StreamSubscription subscription;
    final streamSubscription = stream.listen((data) {
      final newSnapshot =
          AsyncSnapshot<T>.withData(ConnectionState.active, data);
      if (!shouldRebuild(
        context,
        stream,
        oldValue: subscription.snapshot,
        newValue: newSnapshot,
      )) {
        return;
      }

      subscription.snapshot = newSnapshot;
      element.markNeedsBuild();
    }, onError: (Object error, StackTrace stackTrace) {
      final newSnapshot =
          AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);
      if (!shouldRebuild(
        context,
        stream,
        oldValue: subscription.snapshot,
        newValue: newSnapshot,
      )) {
        return;
      }

      subscription.snapshot = newSnapshot;
      element.markNeedsBuild();
    }, onDone: () {
      final newSnapshot = subscription.snapshot.inState(ConnectionState.done);
      if (!shouldRebuild(
        context,
        stream,
        oldValue: subscription.snapshot,
        newValue: newSnapshot,
      )) {
        return;
      }

      subscription.snapshot = newSnapshot;
      element.markNeedsBuild();
    });

    subscription = _StreamSubscription(
      streamSubscription: streamSubscription,
      snapshot: _initialSnapshot<T>(stream),
    );

    return subscription;
  }
}

AsyncSnapshot<T> _initialSnapshot<T>(Stream stream) {
  if (stream is ValueStream<T>) {
    if (stream.hasValue) {
      return AsyncSnapshot<T>.withData(
        ConnectionState.waiting,
        stream.value,
      );
    }
    if (stream.hasError) {
      if (stream.stackTrace != null) {
        return AsyncSnapshot<T>.withError(
          ConnectionState.waiting,
          stream.error,
          stream.stackTrace!,
        );
      }
      return AsyncSnapshot<T>.withError(
        ConnectionState.waiting,
        stream.error,
      );
    }
  }
  return AsyncSnapshot<T>.nothing().inState(ConnectionState.waiting);
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
    final watchRoot = InheritedContextWatch.of(context);
    final subscription =
        watchRoot.watch<T>(context, this) as _StreamSubscription?;
    if (subscription == null) {
      // Subscription is null when the method is called outside of the build()
      // method.
      return AsyncSnapshot<T>.nothing();
    }
    return subscription.snapshot as AsyncSnapshot<T>;
  }
}

extension StreamContextWatchValueExtension<T> on Stream<T> {
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
  ) {
    final watchRoot = InheritedContextWatch.of(context);
    final subscription = watchRoot.watch<T>(context, this, selector: selector)
        as _StreamSubscription?;
    if (subscription == null) {
      // Subscription is null when the method is called outside of the build()
      // method.
      return selector(AsyncSnapshot<T>.nothing());
    }
    return selector(subscription.snapshot as AsyncSnapshot<T>);
  }
}
