import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

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

extension StreamContextWatchExtension<T> on ValueStream<T> {
  T watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: this,
    );
    return value;
  }
}
