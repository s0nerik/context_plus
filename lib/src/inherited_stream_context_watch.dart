import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

import 'inherited_context_watch.dart';

@internal
class InheritedStreamContextWatch
    extends InheritedContextWatch<Stream, StreamSubscription> {
  const InheritedStreamContextWatch({
    super.key,
    required super.child,
  });

  @override
  ObservableNotifierInheritedElement<Stream, StreamSubscription>
      createElement() => InheritedStreamContextWatchElement(this);
}

@internal
class InheritedStreamContextWatchElement
    extends ObservableNotifierInheritedElement<Stream, StreamSubscription> {
  InheritedStreamContextWatchElement(super.widget);

  @override
  StreamSubscription watch(Stream observable, void Function() callback) {
    return observable.listen((_) => callback());
  }

  @override
  void unwatch(Stream observable, StreamSubscription subscription) {
    subscription.cancel();
  }
}

extension StreamContextWatchExtension<T> on Stream<T> {
  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: this,
    );
  }
}

extension ValueStreamContextWatchExtension<T> on ValueStream<T> {
  /// Watch this [ValueStream] for changes.
  ///
  /// Whenever this [ValueStream] emits new value (except for initial value),
  /// the [context] will be rebuilt.
  ///
  /// Returns the current value of the [ValueStream].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: this,
    );
    return value;
  }
}
