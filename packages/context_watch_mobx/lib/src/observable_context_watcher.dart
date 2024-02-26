import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

class _MobxSubscription implements ContextWatchSubscription {
  _MobxSubscription({
    required this.observable,
    required this.dispose,
  });

  final Observable observable;
  final VoidCallback dispose;

  @override
  void cancel() => dispose();
}

class MobxObservableWatcher extends ContextWatcher<Observable> {
  MobxObservableWatcher._();

  static final instance = MobxObservableWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    Observable observable,
  ) {
    return _MobxSubscription(
      observable: observable,
      dispose: observable.observe(
        (notification) =>
            rebuildIfNeeded(context, observable, value: notification.newValue),
      ),
    );
  }
}

extension MobxObservableContextWatchExtension<T> on Observable<T> {
  /// Watch this [Observable] for changes.
  ///
  /// Whenever this [Observable] emits new value, the [context] will be
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

extension MobxObservableContextWatchOnlyExtension<T> on Observable<T> {
  /// Watch this [Observable] for changes.
  ///
  /// Whenever this [Observable] emits new value, if [selector]
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
