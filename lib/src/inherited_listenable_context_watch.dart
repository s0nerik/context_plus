import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedListenableContextWatch
    extends InheritedContextWatch<Listenable, StreamSubscription> {
  const InheritedListenableContextWatch({
    super.key,
    required super.child,
  });

  @override
  ObservableNotifierInheritedElement<Listenable, StreamSubscription>
      createElement() => InheritedListenableContextWatchElement(this);
}

@internal
class InheritedListenableContextWatchElement
    extends ObservableNotifierInheritedElement<Listenable, StreamSubscription> {
  InheritedListenableContextWatchElement(super.widget);

  final _streamControllers = HashMap<Listenable, StreamController>();
  final _actualListeners = HashMap<Listenable, VoidCallback>();

  @override
  StreamSubscription watch(
    BuildContext context,
    Listenable observable,
    VoidCallback callback,
  ) {
    // ignore: cancel_subscriptions
    late final StreamController ctrl;
    if (!_streamControllers.containsKey(observable)) {
      ctrl = StreamController.broadcast();
      _streamControllers[observable] = ctrl;
      _actualListeners[observable] = () {
        if (!canNotify(context, observable)) {
          return;
        }
        ctrl.add(null);
      };
      observable.addListener(_actualListeners[observable]!);
    } else {
      ctrl = _streamControllers[observable]!;
    }

    return ctrl.stream.listen((_) => callback());
  }

  @override
  void unwatch(
    BuildContext context,
    Listenable observable,
    StreamSubscription subscription,
  ) {
    subscription.cancel();
    if (_streamControllers[observable]?.hasListener == false) {
      observable.removeListener(_actualListeners[observable]!);
      _streamControllers[observable]!.close();
      _streamControllers.remove(observable);
      _actualListeners.remove(observable);
    }
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
    watchRoot.subscribe(context as Element, this);
    return value;
  }
}
