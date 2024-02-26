import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

class _BlocSubscription implements ContextWatchSubscription {
  _BlocSubscription({
    required StreamSubscription<dynamic> streamSubscription,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;

  @override
  void cancel() => _sub.cancel();
}

class BlocContextWatcher extends ContextWatcher<StateStreamable> {
  BlocContextWatcher._();

  static final instance = BlocContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, StateStreamable observable) {
    final bloc = observable;

    return _BlocSubscription(
      streamSubscription: bloc.stream.listen(
        (data) => rebuildIfNeeded(context, bloc, value: data),
      ),
    );
  }
}

extension BlocContextWatchExtension<T> on StateStreamable<T> {
  /// Watch this [StateStreamable] for changes.
  ///
  /// Whenever this [StateStreamable] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch<T>(context, this);
    return state;
  }
}

extension BlocContextWatchOnlyExtension<T> on StateStreamable<T> {
  /// Watch this [StateStreamable] for changes.
  ///
  /// Whenever this [StateStreamable] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch<T>(context, this, selector: selector);
    return selector(state);
  }
}
