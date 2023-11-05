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
    Key? key,
    required super.child,
  }) : super(key: key);

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
    Listenable observable,
    VoidCallback callback,
  ) {
    late final StreamController ctrl;
    if (!_streamControllers.containsKey(observable)) {
      ctrl = StreamController.broadcast();
      _streamControllers[observable] = ctrl;
      _actualListeners[observable] = () => ctrl.add(null);
      observable.addListener(_actualListeners[observable]!);
    } else {
      ctrl = _streamControllers[observable]!;
    }

    return ctrl.stream.listen((_) => callback());
  }

  @override
  void unwatch(Listenable observable, StreamSubscription subscription) {
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
  void watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedListenableContextWatch>(
      aspect: this,
    );
  }
}

extension ValueListenableContextWatchExtension<T> on ValueListenable<T> {
  T watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedListenableContextWatch>(
      aspect: this,
    );
    return value;
  }
}
