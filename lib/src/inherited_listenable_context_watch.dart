import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedListenableContextWatch
    extends InheritedContextWatch<Listenable, VoidCallback> {
  const InheritedListenableContextWatch({
    Key? key,
    required super.child,
  }) : super(key: key);

  @override
  ObservableNotifierInheritedElement<Listenable, VoidCallback>
      createElement() => InheritedListenableContextWatchElement(this);
}

class InheritedListenableContextWatchElement
    extends ObservableNotifierInheritedElement<Listenable, VoidCallback> {
  InheritedListenableContextWatchElement(super.widget);

  @override
  VoidCallback watch(
    Listenable observable,
    VoidCallback callback,
  ) {
    observable.addListener(callback);
    return callback;
  }

  @override
  void unwatch(Listenable observable, VoidCallback subscription) {
    observable.removeListener(subscription);
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
