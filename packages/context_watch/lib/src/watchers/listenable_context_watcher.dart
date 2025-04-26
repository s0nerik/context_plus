import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
class ContextWatchListenableSubscription implements ContextWatchSubscription {
  ContextWatchListenableSubscription({
    required this.listenable,
    required this.listener,
  }) {
    listenable.addListener(listener);
  }

  final Listenable listenable;
  final VoidCallback listener;

  @override
  get callbackArgument => listenable;

  @override
  void cancel() => listenable.removeListener(listener);
}

@internal
class ListenableContextWatcher extends ContextWatcher<Listenable> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Listenable observable,
  ) {
    final element = context as Element;
    return _createListenableSubscription(element, observable);
  }

  ContextWatchSubscription _createListenableSubscription(
    Element element,
    Listenable listenable,
  ) {
    return ContextWatchListenableSubscription(
      listenable: listenable,
      listener: () => rebuildIfNeeded(element, listenable),
    );
  }
}
