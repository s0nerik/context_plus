import 'dart:async';
import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../observable/observable.dart';

class ContextWatchRoot extends StatelessWidget {
  const ContextWatchRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InheritedObservableNotifier extends InheritedWidget {
  const InheritedObservableNotifier({
    Key? key,
    required super.child,
  }) : super(key: key);

  @override
  InheritedElement createElement() => ObservableNotifierInheritedElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class ObservableNotifierInheritedElement extends InheritedElement {
  ObservableNotifierInheritedElement(super.widget);

  final _elementSubs =
      HashMap<Element, HashMap<Observable, StreamSubscription>>();
  final _frameElementSubs =
      HashMap<Element, HashMap<Observable, StreamSubscription>>();
  final _manuallyUnwatchedElements = HashSet<Element>();

  bool _isFirstFrame = true;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    SchedulerBinding.instance.addPostFrameCallback(_onPostFrame);
  }

  @override
  void unmount() {
    _clearAllSubscriptions();
    super.unmount();
  }

  @override
  void reassemble() {
    _clearAllSubscriptions();
    super.reassemble();
  }

  void _onPostFrame(_) {
    if (!mounted) return;
    _isFirstFrame = false;
    _manuallyUnwatchedElements.clear();
    _clearSubscriptionsForUnwatchedObservables();
    _clearSubscriptionsForUnmountedElements();
    SchedulerBinding.instance.addPostFrameCallback(_onPostFrame);
  }

  // Workaround for https://github.com/flutter/flutter/issues/106549
  void _clearSubscriptionsForUnwatchedObservables() {
    // dispose all subscriptions that are no longer present in the frame
    // subscriptions map, but only for elements that are present within the
    // frame element subscriptions map
    for (final element in _frameElementSubs.keys) {
      final frameObservableSubs = _frameElementSubs[element]!;
      final observableSubs = _elementSubs[element]!;
      for (final observable in observableSubs.keys) {
        if (!frameObservableSubs.containsKey(observable)) {
          final sub = observableSubs[observable]!;
          sub.cancel();
        }
      }
      _elementSubs[element] = frameObservableSubs;
      if (observableSubs.isEmpty) {
        _elementSubs.remove(element);
      }
    }
    _frameElementSubs.clear();
  }

  // Workaround for https://github.com/flutter/flutter/issues/128432
  void _clearSubscriptionsForUnmountedElements() {
    final unmountedElements = <Element>[];
    for (final element in _elementSubs.keys) {
      if (!element.mounted) {
        unmountedElements.add(element);
      }
    }
    for (final element in unmountedElements) {
      _disposeDependentSubscriptions(element);
    }
  }

  void _disposeDependentSubscriptions(Element dependent) {
    final observableSubs = _elementSubs[dependent];
    if (observableSubs == null) {
      return;
    }

    for (final sub in observableSubs.values) {
      sub.cancel();
    }
    _elementSubs.remove(dependent);
  }

  void _clearAllSubscriptions() {
    _frameElementSubs.clear();
    _manuallyUnwatchedElements.clear();

    for (final observableSubs in _elementSubs.values) {
      for (final sub in observableSubs.values) {
        sub.cancel();
      }
    }
    _elementSubs.clear();
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    final isBuildPhase = phase == SchedulerPhase.persistentCallbacks ||
        _isFirstFrame && phase == SchedulerPhase.idle;

    if (!isBuildPhase) {
      // Don't update subscriptions outside the build phase
      return;
    }

    if (aspect == null) {
      if (_manuallyUnwatchedElements.contains(dependent)) {
        return;
      }
      _disposeDependentSubscriptions(dependent);
      _manuallyUnwatchedElements.add(dependent);
      return;
    }

    final observable = aspect as Observable;

    _elementSubs[dependent] ??= HashMap<Observable, StreamSubscription>();
    final observableSubs = _elementSubs[dependent]!;
    observableSubs[observable] ??= observable.stream.listen((_) {
      dependent.markNeedsBuild();
    });

    _frameElementSubs[dependent] ??= HashMap<Observable, StreamSubscription>();
    final frameObservableSubs = _frameElementSubs[dependent]!;
    frameObservableSubs[observable] = observableSubs[observable]!;
  }
}
