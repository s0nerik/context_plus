import 'package:flutter/foundation.dart';
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
