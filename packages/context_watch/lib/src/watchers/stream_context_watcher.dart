// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

class _StreamSubscription implements ContextWatchSubscription {
  _StreamSubscription({
    required this.observable,
    required StreamSubscription streamSubscription,
    required this.snapshot,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;
  AsyncSnapshot snapshot;

  @override
  final Stream observable;

  @override
  get hasValue => true;

  @override
  get value => snapshot;

  @override
  get selectorParameterType => ContextWatchSelectorParameterType.value;

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
      rebuildIfNeeded(context, stream);
    }, onError: (Object error, StackTrace stackTrace) {
      final newSnapshot =
          AsyncSnapshot<T>.withError(ConnectionState.active, error, stackTrace);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, stream);
    }, onDone: () {
      final newSnapshot = subscription.snapshot.inState(ConnectionState.done);
      subscription.snapshot = newSnapshot;
      rebuildIfNeeded(context, stream);
    });

    subscription = _StreamSubscription(
      observable: stream,
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

/// Mimics the interface of a `ValueStream` from `rxdart` without having an
/// actual dependency on the [rxdart] package.
///
/// Additionally it supports the `ValueStream` from
/// rxdart:0.26.0 https://github.com/ReactiveX/rxdart/releases/tag/0.26.0 (introduced)
/// rxdart:0.27.0 https://github.com/ReactiveX/rxdart/releases/tag/0.27.0 (breaking)
/// rxdart:0.28.0 https://github.com/ReactiveX/rxdart/releases/tag/0.28.0 (non-breaking)
abstract class SupportValueStream<T> {
  /// Casts a [Stream] to a [_SupportValueStream] if it passed the duck test
  static SupportValueStream<T>? cast<T>(Stream<T> stream) {
    final vs27 = SupportValueStream27to28.cast(stream);
    if (vs27 != null) {
      return vs27;
    }

    final vs26 = SupportValueStream26.cast(stream);
    if (vs26 != null) {
      return vs26;
    }
    return null;
  }

  bool get hasValue;
  T get value;
  bool get hasError;
  Object get error;
  StackTrace? get stackTrace;
}

/// rxdart:0.27.x ValueStream
/// https://github.com/ReactiveX/rxdart/blob/61512993d0ba3852f68537cf2e0b2a167d8178f8/lib/src/streams/value_stream.dart#L2
/// rxdart:0.28.x ValueStream
/// https://github.com/ReactiveX/rxdart/blob/0.28.0/packages/rxdart/lib/src/streams/value_stream.dart#L5
///
/// Both are identical based on our SupportValueStream interface
class SupportValueStream27to28<T> implements SupportValueStream<T> {
  final Stream<T> stream;

  @visibleForTesting
  SupportValueStream27to28(this.stream);

  /// Casts a [Stream] to a [_SupportValueStream] if it passed the duck test
  static SupportValueStream27to28<T>? cast<T>(Stream<T> stream) {
    final valueStream = SupportValueStream27to28(stream);
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

  @override
  bool get hasValue {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.hasValue;
    if (result is bool) {
      return result;
    }
    throw StateError(
        'Stream.hasValue does not return a boolean, but ${result.runtimeType}');
  }

  @override
  T get value {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.value;
    if (result is T) {
      return result;
    }
    throw StateError('Stream.value is of type ${result.runtimeType}, not $T');
  }

  @override
  bool get hasError {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.hasError;
    if (result is bool) {
      return result;
    }
    throw StateError(
        'Stream.hasError does not return a boolean, but ${result.runtimeType}');
  }

  @override
  Object get error {
    final dynamic dynamicStream = stream;
    final result = dynamicStream.error;
    if (result is Object) {
      return result;
    }
    throw StateError(
        'Stream.error is of type ${result.runtimeType}, not Object');
  }

  @override
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

/// rxdart:0.26.x ValueStream
/// https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/streams/value_stream.dart#L5
class SupportValueStream26<T> implements SupportValueStream<T> {
  final Stream<T> stream;

  @visibleForTesting
  SupportValueStream26(this.stream);

  /// Tries to casts a [Stream] to `ValueStream` from rxdart:0.26.0 if it passed the duck test
  static SupportValueStream26<T>? cast<T>(Stream<T> stream) {
    final valueStream = SupportValueStream26(stream);
    try {
      // Duck test: If it looks like a duck, swims like a duck, and quacks like a duck, then it probably is a duck.
      // try to access all methods that make a ValueStream a ValueStream
      valueStream.valueWrapper;
      valueStream.errorAndStackTrace;
      // supports all used methods/getters, so it is a ValueStream
      return valueStream;
    } catch (e) {
      return null;
    }
  }

  dynamic /*ValueWrapper?*/ get valueWrapper {
    final dynamic dynamicStream = stream;
    final dynamic wrapper = dynamicStream.valueWrapper;
    if (wrapper == null) {
      return wrapper;
    }
    final value = wrapper.value;
    if (value is T) {
      return wrapper;
    }
    throw StateError(
        'Stream.valueWrapper.value is of type ${value.runtimeType}, not $T');
  }

  dynamic /*ErrorAndStackTrace?*/ get errorAndStackTrace {
    final dynamic dynamicStream = stream;
    final union = dynamicStream.errorAndStackTrace;
    if (union == null) {
      return union;
    }
    final error = union.error;
    if (error is! Object) {
      throw StateError(
          'Stream.errorAndStackTrace.error is of type ${error.runtimeType}, not Object');
    }
    final stackTrace = union.stackTrace;
    if (stackTrace is! StackTrace?) {
      throw StateError(
          'Stream.errorAndStackTrace.stackTrace is of type ${stackTrace.runtimeType}, not StackTrace?');
    }
    return union;
  }

  @override
  bool get hasValue {
    // match https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/streams/value_stream.dart#L20
    return valueWrapper != null;
  }

  @override
  T get value {
    // match https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/streams/value_stream.dart#L23
    return valueWrapper?.value;
  }

  @override
  bool get hasError {
    // match https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/streams/value_stream.dart#L43
    return errorAndStackTrace != null;
  }

  @override
  Object get error {
    // match https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/streams/value_stream.dart#L46
    return errorAndStackTrace?.error;
  }

  @override
  StackTrace? get stackTrace {
    // access https://github.com/ReactiveX/rxdart/blob/0.26.0/lib/src/utils/error_and_stacktrace.dart#L8
    return errorAndStackTrace?.stackTrace;
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
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return AsyncSnapshot<T>.nothing();

    observable.watch();

    final subscription = observable.subscription as _StreamSubscription;
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
    R Function(AsyncSnapshot<T> snapshot) selector,
  ) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(AsyncSnapshot<T>.nothing());

    final subscription = observable.subscription as _StreamSubscription;
    final selectedValue = selector(subscription.snapshot as AsyncSnapshot<T>);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }
}

extension StreamContextWatchEffectExtension<T> on Stream<T> {
  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [effect] will be called,
  /// *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   stream.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   stream.unwatchEffect(context, key: 'effect');
  /// }
  /// ```
  ///
  /// If [immediate] is `true`, the effect will be called upon effect
  /// registration immediately. If [once] is `true`, the effect will be called
  /// only once. These parameters can be combined.
  ///
  /// [immediate] and [once] parameters require a unique [key].
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T> snapshot) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }
}

extension StreamContextUnwatchEffectExtension on Stream {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Stream] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
