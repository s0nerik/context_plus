import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedStreamContextWatch
    extends InheritedContextWatch<Stream, StreamSubscription> {
  const InheritedStreamContextWatch({
    Key? key,
    required super.child,
  }) : super(key: key);

  @override
  StreamSubscription watch(Stream observable, void Function() callback) {
    return observable.listen((_) => callback());
  }

  @override
  void unwatch(Stream observable, StreamSubscription subscription) {
    subscription.cancel();
  }
}
