import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class _Subscription implements ContextWatchSubscription {
  _Subscription({
    required this.listenable,
    required this.listener,
  }) {
    listenable.addListener(listener);
  }

  final Listenable listenable;
  final VoidCallback listener;

  @override
  Object? getData() => null;

  @override
  void cancel() => listenable.removeListener(listener);
}

class ListenableContextWatcher extends ContextWatcher<Listenable> {
  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Listenable observable,
  ) {
    final element = context as Element;
    return _Subscription(
      listenable: observable,
      listener: () {
        if (!canNotify(context, observable)) {
          return;
        }
        element.markNeedsBuild();
      },
    );
  }
}

extension ListenableContextWatchExtension on Listenable {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    context.dependOnInheritedElement(watchRoot);
    watchRoot.watch(context, this);
  }
}

extension ValueListenableContextWatchExtension<T> on ValueListenable<T> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current value of the [ValueListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    final watchRoot =
        context.getElementForInheritedWidgetOfExactType<InheritedContextWatch>()
            as InheritedContextWatchElement;
    context.dependOnInheritedElement(watchRoot);
    watchRoot.watch(context, this);
    return value;
  }
}
