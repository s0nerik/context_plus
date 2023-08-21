import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
abstract class InheritedContextWatch<TObservable extends Object,
    TSubscription extends Object> extends InheritedWidget {
  const InheritedContextWatch({
    Key? key,
    required super.child,
  }) : super(key: key);

  @override
  ObservableNotifierInheritedElement<TObservable, TSubscription>
      createElement();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

@internal
abstract class ObservableNotifierInheritedElement<TObservable extends Object,
    TSubscription extends Object> extends InheritedElement {
  ObservableNotifierInheritedElement(super.widget);

  final _elementSubs = HashMap<Element, HashMap<TObservable, TSubscription>>();
  final _frameElementSubs =
      HashMap<Element, HashMap<TObservable, TSubscription>>();
  final _manuallyUnwatchedElements = HashSet<Element>();

  bool _isFirstFrame = true;

  @protected
  TSubscription watch(TObservable observable, void Function() callback);

  @protected
  void unwatch(TObservable observable, TSubscription subscription);

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
          unwatch(observable, sub);
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

    for (final observable in observableSubs.keys) {
      final sub = observableSubs[observable]!;
      unwatch(observable, sub);
    }
    _elementSubs.remove(dependent);
  }

  void _clearAllSubscriptions() {
    _frameElementSubs.clear();
    _manuallyUnwatchedElements.clear();

    for (final observableSubs in _elementSubs.values) {
      for (final entry in observableSubs.entries) {
        unwatch(entry.key, entry.value);
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

    final observable = aspect as TObservable;

    final observableSubs = (_elementSubs[dependent] ??= HashMap());
    observableSubs[observable] ??= watch(observable, dependent.markNeedsBuild);

    final frameObservableSubs = (_frameElementSubs[dependent] ??= HashMap());
    frameObservableSubs[observable] = observableSubs[observable]!;
  }
}
