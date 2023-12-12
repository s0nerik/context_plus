import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:state_beacon/state_beacon.dart';

class _Subscription implements ContextWatchSubscription {
  _Subscription({
    required this.beacon,
    required this.dispose,
  });

  final ReadableBeacon<dynamic> beacon;
  final VoidCallback dispose;

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

    late final _Subscription subscription;
    final dispose = beacon.subscribe((value) {
      if (!canNotify(context, observable)) {
        return;
      }
      element.markNeedsBuild();
    });
    subscription = _Subscription(
      beacon: beacon,
      dispose: dispose,
    );
    return subscription;
  }
}

extension BeaconContextWatchExtension<T> on ReadableBeacon<T> {
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
