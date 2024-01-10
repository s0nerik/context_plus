import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class _Subscription implements ContextWatchSubscription {
  _Subscription({
    required StreamSubscription<dynamic> streamSubscription,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;

  dynamic value;

  @override
  Object? getData() => null;

  @override
  void cancel() => _sub.cancel();
}

class GetxContextWatcher extends ContextWatcher<Rx> {
  GetxContextWatcher._();

  static final instance = GetxContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, Rx observable) {
    final element = context as Element;

    late final _Subscription subscription;

    final streamSubscription = observable.stream.listen((data) {
      if (!shouldRebuild(
        context,
        observable,
        oldValue: subscription.value,
        newValue: data,
      )) {
        return;
      }
      subscription.value = data;
      element.markNeedsBuild();
    });

    subscription = _Subscription(
      streamSubscription: streamSubscription,
    );

    return subscription;
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
