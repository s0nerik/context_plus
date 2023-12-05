import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedListenableContextWatch
    extends InheritedContextWatch<Listenable, VoidCallback> {
  const InheritedListenableContextWatch({
    super.key,
    required super.child,
  });

  @override
  InheritedContextWatchElement<Listenable, VoidCallback> createElement() =>
      InheritedListenableContextWatchElement(this);
}

@internal
class InheritedListenableContextWatchElement
    extends InheritedContextWatchElement<Listenable, VoidCallback> {
  InheritedListenableContextWatchElement(super.widget);

  final _contextListenableListeners =
      HashMap<BuildContext, HashMap<Listenable, VoidCallback>>.identity();

  @override
  VoidCallback watch<T>(
    BuildContext context,
    Listenable observable,
  ) {
    final element = context as Element;
    final listeners =
        _contextListenableListeners[context] ??= HashMap.identity();

    final existingListener = listeners[observable];
    if (existingListener != null) {
      return existingListener;
    }

    final listener = listeners[observable] = () {
      if (!canNotify(context, observable)) {
        return;
      }
      element.markNeedsBuild();
    };
    observable.addListener(listener);

    return listener;
  }

  @override
  void unwatch(
    BuildContext context,
    Listenable observable,
  ) {
    final listeners = _contextListenableListeners[context];
    if (listeners == null) {
      return;
    }
    final listener = listeners.remove(observable);
    if (listener == null) {
      return;
    }
    observable.removeListener(listener);
  }

  @override
  void unwatchContext(BuildContext context) {
    final listeners = _contextListenableListeners.remove(context);
    if (listeners == null) {
      return;
    }
    for (final MapEntry(key: listenable, value: listener)
        in listeners.entries) {
      listenable.removeListener(listener);
    }
  }

  @override
  void unwatchAllContexts() {
    for (final listeners in _contextListenableListeners.values) {
      for (final MapEntry(key: listenable, value: listener)
          in listeners.entries) {
        listenable.removeListener(listener);
      }
    }
    _contextListenableListeners.clear();
  }
}

extension ListenableContextWatchExtension on Listenable {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) {
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
            InheritedListenableContextWatch>()
        as InheritedListenableContextWatchElement;
    context.dependOnInheritedElement(watchRoot);
    watchRoot.subscribe(context as Element, this);
  }
}

extension ValueListenableContextWatchExtension<T> on ValueListenable<T> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current value of the [ValueListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    final watchRoot = context.getElementForInheritedWidgetOfExactType<
            InheritedListenableContextWatch>()
        as InheritedListenableContextWatchElement;
    context.dependOnInheritedElement(watchRoot);
    watchRoot.subscribe<T>(context as Element, this);
    return value;
  }
}
