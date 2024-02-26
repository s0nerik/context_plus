import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:state_beacon/state_beacon.dart';

class _BeaconSubscription implements ContextWatchSubscription {
  _BeaconSubscription({
    required this.beacon,
    required this.dispose,
  });

  final ReadableBeacon<dynamic> beacon;
  final VoidCallback dispose;

  @override
  void cancel() => dispose();
}

class BeaconContextWatcher extends ContextWatcher<ReadableBeacon> {
  BeaconContextWatcher._();

  static final instance = BeaconContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, ReadableBeacon<dynamic> observable) {
    final beacon = observable;

    return _BeaconSubscription(
      beacon: beacon,
      dispose: beacon.subscribe(
        (value) => rebuildIfNeeded(context, observable, value: value),
      ),
    );
  }
}

extension BeaconContextWatchExtension<T> on ReadableBeacon<T> {
  /// Watch this [Beacon] for changes.
  ///
  /// Whenever this [Beacon] emits new value, the [context] will be
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

extension BeaconContextWatchValueExtension<T> on ReadableBeacon<T> {
  /// Watch this [Beacon] for changes.
  ///
  /// Whenever this [Beacon] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchValue<R>(BuildContext context, R Function(T value) selector) {
    final watchRoot = InheritedContextWatch.of(context);
    watchRoot.watch(context, this, selector: selector);
    return selector(value);
  }
}
