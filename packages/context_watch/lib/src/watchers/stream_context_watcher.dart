import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

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

    late final _StreamSubscription subscription;
    final streamSubscription = stream.listen((data) {
      final newSnapshot =
          AsyncSnapshot<T>.withData(ConnectionState.active, data);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, stream, value: newSnapshot);
    }, onError: (Object error, StackTrace stackTrace) {
      final newSnapshot =
          AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, stream, value: newSnapshot);
    }, onDone: () {
      final newSnapshot = subscription.snapshot.inState(ConnectionState.done);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, stream, value: newSnapshot);
    });

    subscription = _StreamSubscription(
      streamSubscription: streamSubscription,
      snapshot: _initialSnapshot<T>(stream),
    );

    return subscription;
  }
}

AsyncSnapshot<T> _initialSnapshot<T>(Stream stream) {
  final supportValueStream = SupportValueStream.cast(stream);
  if (supportValueStream != null) {
    if (supportValueStream.hasValue) {
      return AsyncSnapshot<T>.withData(
        ConnectionState.waiting,
        supportValueStream.value,
      );
    }
    if (supportValueStream.hasError) {
      return AsyncSnapshot<T>.withError(
        ConnectionState.waiting,
        supportValueStream.error,
        supportValueStream.stackTrace ?? StackTrace.empty,
      );
    }
  }
  return AsyncSnapshot<T>.nothing().inState(ConnectionState.waiting);
}

/// Mimics the interface of a `ValueStream` from `rx_dart` without having an
/// actual dependency on the [rx_dart] package.
class SupportValueStream<T> {
  final Stream<T> stream;

  @visibleForTesting
  SupportValueStream(this.stream);

  /// Casts a [Stream] to a [_SupportValueStream] if it passed the duck test
  static SupportValueStream<T>? cast<T>(Stream<T> stream) {
    final valueStream = SupportValueStream(stream);
    try {
      // Duck test: If it looks like a duck, swims like a duck, and quacks like a duck, then it probably is a duck.
      // try to access all methods that make a ValueStream a ValueStream
      if (valueStream.hasValue) {
        valueStream.value;
      }
      if (valueStream.hasError) {
        valueStream.error;
        valueStream.stackTrace;
      }
      // supports all used methods/getters, so it is a ValueStream
      return valueStream;
    } catch (e) {
      return null;
    }
  }

  bool get hasValue {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.hasValue;
    if (result is bool) {
      return result;
    }
    throw StateError(
        'Stream.hasValue does not return a boolean, but ${result.runtimeType}');
  }

  T get value {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.value;
    if (result is T) {
      return result;
    }
    throw StateError('Stream.value is of type ${result.runtimeType}, not $T');
  }

  bool get hasError {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.hasError;
    if (result is bool) {
      return result;
    }
    throw StateError(
        'Stream.hasError does not return a boolean, but ${result.runtimeType}');
  }

  Object get error {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.error;
    if (result is Object) {
      return result;
    }
    throw StateError(
        'Stream.error is of type ${result.runtimeType}, not Object');
  }

  StackTrace? get stackTrace {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.stackTrace;
    if (result is StackTrace?) {
      return result;
    }
    throw StateError(
        'Stream.stackTrace is of type ${result.runtimeType}, not StackTrace');
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

extension StreamContextWatchOnlyExtension<T> on Stream<T> {
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
