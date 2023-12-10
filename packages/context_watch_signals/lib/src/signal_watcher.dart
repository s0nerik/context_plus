import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';

class _Subscription implements ContextWatchSubscription {
  _Subscription({
    required this.signal,
    required this.dispose,
  });

  final ReadonlySignal<dynamic> signal;
  final VoidCallback dispose;

  @override
  Object? getData() => null;

  @override
  void cancel() => dispose();
}

class SignalContextWatcher extends ContextWatcher<ReadonlySignal> {
  SignalContextWatcher._();

  static final instance = SignalContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, ReadonlySignal<dynamic> observable) {
    final signal = observable;
    final element = context as Element;

    late final _Subscription subscription;
    final dispose = signal.subscribe((value) {
      if (!canNotify(context, observable)) {
        return;
      }
      element.markNeedsBuild();
    });
    subscription = _Subscription(
      signal: signal,
      dispose: dispose,
    );
    return subscription;
  }
}

extension SignalContextWatchExtension<T> on ReadonlySignal<T> {
  /// Watch this [Signal] for changes.
  ///
  /// Whenever this [Signal] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    final watchRoot = InheritedContextWatch.of(context);
    context.dependOnInheritedElement(watchRoot);
    watchRoot.watch<T>(context, this);
    return value;
  }
}
