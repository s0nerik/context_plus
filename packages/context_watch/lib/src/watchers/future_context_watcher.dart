// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
class FutureSubscription implements ContextWatchSubscription {
  FutureSubscription({required this.snapshot});

  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;

  AsyncSnapshot snapshot;

  @override
  get callbackArgument => snapshot;

  @override
  void cancel() => _isCanceled = true;
}

@internal
class FutureContextWatcher extends ContextWatcher<Future> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Future observable,
  ) {
    final subscription = FutureSubscription(
      snapshot: AsyncSnapshot<T>.nothing(),
    );
    observable.then(
      (data) {
        if (subscription.isCanceled) {
          return;
        }

        final newSnapshot = AsyncSnapshot<T>.withData(
          ConnectionState.done,
          data,
        );
        subscription.snapshot = newSnapshot;
        rebuildIfNeeded(context, observable);
      },
      onError: (Object error, StackTrace stackTrace) {
        if (subscription.isCanceled) {
          return;
        }

        final newSnapshot = AsyncSnapshot<T>.withError(
          ConnectionState.done,
          error,
          stackTrace,
        );
        subscription.snapshot = newSnapshot;
        rebuildIfNeeded(context, observable);
      },
    );
    // An implementation like `SynchronousFuture` may have already called the
    // .then closure. Do not overwrite it in that case.
    if (subscription.snapshot.connectionState != ConnectionState.done) {
      subscription.snapshot = subscription.snapshot.inState(
        ConnectionState.waiting,
      );
    }

    return subscription;
  }
}
