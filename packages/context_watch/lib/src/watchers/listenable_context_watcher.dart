import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class _ListenableSubscription implements ContextWatchSubscription {
  _ListenableSubscription({
    required this.listenable,
    required this.listener,
  }) {
    listenable.addListener(listener);
  }

  final Listenable listenable;
  final VoidCallback listener;

  Object? value;

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
    if (observable is ValueListenable) {
      return _createValueListenableSubscription(element, observable);
    }
    return _createListenableSubscription(element, observable);
  }

  ContextWatchSubscription _createListenableSubscription(
    Element element,
    Listenable listenable,
  ) {
    late final _ListenableSubscription subscription;
    subscription = _ListenableSubscription(
      listenable: listenable,
      listener: () {
        final oldSelection = subscription.value as List<Object?>?;
        final newSelection = getObservableSelection(element, listenable);
        final isSameSelectedValues = listEquals(oldSelection, newSelection);
        final isBothNull = oldSelection == null && newSelection == null;
        if (isSameSelectedValues && !isBothNull) {
          return;
        }
        subscription.value = newSelection;
        if (element.mounted) {
          element.markNeedsBuild();
        }
      },
    );
    return subscription;
  }

  ContextWatchSubscription _createValueListenableSubscription(
    Element element,
    ValueListenable valueListenable,
  ) {
    late final _ListenableSubscription subscription;
    subscription = _ListenableSubscription(
      listenable: valueListenable,
      listener: () {
        if (!shouldRebuild(
          element,
          valueListenable,
          oldValue: subscription.value,
          newValue: valueListenable.value,
        )) {
          return;
        }
        subscription.value = valueListenable.value;
        element.markNeedsBuild();
      },
    );
    return subscription;
  }
}

extension ListenableContextWatchExtension<TListenable extends Listenable>
    on TListenable {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  ///
  /// Returns this [Listenable].
  TListenable watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch(context, this);
    return this;
  }
}

extension ListenableContextWatchOnlyExtension<TListenable extends Listenable>
    on TListenable {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable listenable) selector,
  ) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch(context, this, selector: selector);
    return selector(this);
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
  T watchValue(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch(context, this);
    return value;
  }
}

extension ValueListenableContextWatchValueExtension<T> on ValueListenable<T> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchValueOnly<R>(BuildContext context, R Function(T value) selector) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch(context, this, selector: selector);
    return selector(value);
  }
}
