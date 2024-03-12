import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:signals_flutter/signals_flutter.dart';

class _SignalsSubscription implements ContextWatchSubscription {
  _SignalsSubscription({
    required this.signal,
    required this.dispose,
  });

  final ReadonlySignal<dynamic> signal;
  final VoidCallback dispose;

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

    return _SignalsSubscription(
      signal: signal,
      dispose: signal.subscribe(
        (value) => rebuildIfNeeded(context, observable, value: value),
      ),
    );
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
    watchRoot.watch<T>(context, this);
    return value;
  }
}

extension SignalContextWatchValueExtension<T> on ReadonlySignal<T> {
  /// Watch this [Signal] for changes.
  ///
  /// Whenever this [Signal] emits new value, if [selector]
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
