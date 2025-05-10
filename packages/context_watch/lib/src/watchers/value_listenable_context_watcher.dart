import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
class ContextWatchValueListenableSubscription<T>
    implements ContextWatchSubscription {
  ContextWatchValueListenableSubscription({
    required this.listenable,
    required this.listener,
  }) {
    listenable.addListener(listener);
  }

  final ValueListenable<T> listenable;
  final VoidCallback listener;

  @override
  get callbackArgument => listenable.value;

  @override
  void cancel() => listenable.removeListener(listener);
}

@internal
class ValueListenableContextWatcher extends ContextWatcher<ValueListenable> {
  ValueListenableContextWatcher()
    : super(ContextWatcherObservableType.valueListenable);

  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    ValueListenable observable,
  ) {
    final element = context as Element;
    return _createListenableSubscription<T>(
      element,
      observable as ValueListenable<T>,
    );
  }

  ContextWatchSubscription _createListenableSubscription<T>(
    Element element,
    ValueListenable<T> listenable,
  ) {
    return ContextWatchValueListenableSubscription(
      listenable: listenable,
      listener: () => rebuildIfNeeded(element, listenable),
    );
  }
}
