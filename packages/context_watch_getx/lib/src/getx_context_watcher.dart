import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class _GetxSubscription implements ContextWatchSubscription {
  _GetxSubscription({
    required StreamSubscription<dynamic> streamSubscription,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;

  @override
  void cancel() => _sub.cancel();
}

class GetxContextWatcher extends ContextWatcher<Rx> {
  GetxContextWatcher._();

  static final instance = GetxContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, Rx observable) {
    return _GetxSubscription(
      streamSubscription: observable.stream
          .listen((data) => rebuildIfNeeded(context, observable, value: data)),
    );
  }
}

extension GetxContextWatchExtension<T> on Rx<T> {
  /// Watch this [Rx] for changes.
  ///
  /// Whenever this [Rx] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch<T>(context, this);
    return value;
  }
}

extension GetxContextWatchOnlyExtension<T> on Rx<T> {
  /// Watch this [Rx] for changes.
  ///
  /// Whenever this [Rx] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch<T>(context, this, selector: selector);
    return selector(value);
  }
}
