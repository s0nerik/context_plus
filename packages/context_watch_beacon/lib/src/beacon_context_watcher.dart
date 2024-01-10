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

  dynamic value;

  @override
  Object? getData() => null;

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
    final element = context as Element;

    late final _BeaconSubscription subscription;
    final dispose = beacon.subscribe((value) {
      if (!shouldRebuild(
        context,
        observable,
        oldValue: subscription.value,
        newValue: value,
      )) {
        return;
      }
      subscription.value = value;
      element.markNeedsBuild();
    });
    subscription = _BeaconSubscription(
      beacon: beacon,
      dispose: dispose,
    );
    return subscription;
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
