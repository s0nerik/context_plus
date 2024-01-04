import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

class _Subscription implements ContextWatchSubscription {
  _Subscription({
    required this.observable,
    required this.dispose,
  });

  final Observable observable;
  final VoidCallback dispose;

  @override
  Object? getData() => null;

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
    final element = context as Element;

    late final _Subscription subscription;
    final dispose = observable.observe((value) {
      if (!canNotify(context, observable)) {
        return;
      }
      element.markNeedsBuild();
    });
    subscription = _Subscription(
      observable: observable,
      dispose: dispose,
    );
    return subscription;
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
