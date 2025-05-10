import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

extension type const ContextWatcherObservableType(int index) {
  static const listenable = ContextWatcherObservableType(0);
  static const valueListenable = ContextWatcherObservableType(1);
  static const stream = ContextWatcherObservableType(2);
  static const future = ContextWatcherObservableType(3);
  static const blocStateStreamable = ContextWatcherObservableType(4);
  static const getxRx = ContextWatcherObservableType(5);
  static const mobxObservable = ContextWatcherObservableType(6);
  static const signal = ContextWatcherObservableType(7);

  static const values = [
    listenable,
    valueListenable,
    stream,
    future,
    blocStateStreamable,
    getxRx,
    mobxObservable,
    signal,
  ];

  String get name => switch (index) {
    0 => 'Listenable',
    1 => 'ValueListenable',
    2 => 'Stream',
    3 => 'Future',
    4 => 'StateStreamable',
    5 => 'Rx',
    6 => 'Observable',
    7 => 'Signal',
    _ => 'Custom type: $index',
  };
}

abstract class ContextWatcher<TObservable extends Object>
    with InternalContextWatcherAPI {
  ContextWatcher(this.type);

  final ContextWatcherObservableType type;

  /// Triggers a rebuild of the [context] if it is interested in the [observable]
  /// value change notification.
  @protected
  @nonVirtual
  void rebuildIfNeeded(BuildContext context, TObservable observable) =>
      rebuildCallback(context, observable);

  @useResult
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    TObservable observable,
  );
}

@internal
mixin InternalContextWatcherAPI {
  var rebuildCallback = neverRebuild;

  static void neverRebuild(BuildContext context, Object observable) {}
}

abstract interface class ContextWatchSubscription {
  /// The argument passed to the .watchOnly() and .watchEffect() callbacks.
  Object? get callbackArgument;

  void cancel();
}
