import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

class _FutureSubscription implements ContextWatchSubscription {
  _FutureSubscription({
    required this.snapshot,
  });

  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;

  AsyncSnapshot snapshot;

  @override
  void cancel() => _isCanceled = true;
}

class FutureContextWatcher extends ContextWatcher<Future> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Future observable,
  ) {
    final element = context as Element;
    final subscription = _FutureSubscription(
      snapshot: AsyncSnapshot<T>.nothing(),
    );
    observable.then((data) {
      if (subscription.isCanceled) {
        return;
      }

      final newSnapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
      if (!shouldRebuild(
        context,
        observable,
        oldValue: subscription.snapshot,
        newValue: newSnapshot,
      )) {
        return;
      }
      subscription.snapshot = newSnapshot;
      element.markNeedsBuild();
    }, onError: (Object error, StackTrace stackTrace) {
      if (subscription.isCanceled) {
        return;
      }

      final newSnapshot =
          AsyncSnapshot<T>.withError(ConnectionState.done, error, stackTrace);
      if (!shouldRebuild(
        context,
        observable,
        oldValue: subscription.snapshot,
        newValue: newSnapshot,
      )) {
        return;
      }
      subscription.snapshot = newSnapshot;
      element.markNeedsBuild();
    });
    // An implementation like `SynchronousFuture` may have already called the
    // .then closure. Do not overwrite it in that case.
    if (subscription.snapshot.connectionState != ConnectionState.done) {
      subscription.snapshot =
          subscription.snapshot.inState(ConnectionState.waiting);
    }

    return subscription;
  }
}

extension FutureContextWatchExtension<T> on Future<T> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    final subscription =
        watchRoot.watch<T>(context, this) as _FutureSubscription?;
    if (subscription == null) {
      // Subscription is null when the method is called outside of the build()
      // method.
      return AsyncSnapshot<T>.nothing();
    }
    return subscription.snapshot as AsyncSnapshot<T>;
  }
}

extension FutureContextWatchValueExtension<T> on Future<T> {
  /// Watch this [Future] for changes.
  ///
  /// Returns the value returned by [selector].
  ///
  /// When this [Future] completes, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchValue<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T> value) selector,
  ) {
    final watchRoot = InheritedContextWatch.of(context);
    final subscription = watchRoot.watch<T>(context, this, selector: selector)
        as _FutureSubscription?;
    if (subscription == null) {
      // Subscription is null when the method is called outside of the build()
      // method.
      return selector(AsyncSnapshot<T>.nothing());
    }
    return selector(subscription.snapshot as AsyncSnapshot<T>);
  }
}
