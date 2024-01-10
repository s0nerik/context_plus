import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';

class _BlocSubscription implements ContextWatchSubscription {
  _BlocSubscription({
    required StreamSubscription<dynamic> streamSubscription,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;

  dynamic value;

  @override
  Object? getData() => null;

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
    final element = context as Element;

    late final _BlocSubscription subscription;

    final streamSubscription = bloc.stream.listen((data) {
      if (!shouldRebuild(
        context,
        bloc,
        oldValue: subscription.value,
        newValue: data,
      )) {
        return;
      }
      subscription.value = data;
      element.markNeedsBuild();
    });

    subscription = _BlocSubscription(
      streamSubscription: streamSubscription,
    );

    return subscription;
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
