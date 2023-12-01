import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
abstract class InheritedContextWatch<TObservable extends Object,
    TSubscription extends Object> extends InheritedWidget {
  const InheritedContextWatch({
    super.key,
    required super.child,
  });

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

  final _contextSubs =
      HashMap<BuildContext, HashMap<TObservable, TSubscription>>();

  final _contextLastFrame = HashMap<BuildContext, Duration>();
  final _contextObservableLastFrame =
      HashMap<BuildContext, HashMap<TObservable, Duration>>();

  Duration _currentFrame = const Duration(milliseconds: -1);
  bool _isFirstFrame = true;

  bool get _isBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        _isFirstFrame && phase == SchedulerPhase.idle;
  }

  @protected
  @useResult
  TSubscription watch(
    BuildContext context,
    TObservable observable,
    void Function() callback,
  );

  @protected
  void unwatch(
    BuildContext context,
    TObservable observable,
    TSubscription subscription,
  );

  @protected
  @useResult
  bool canNotify(BuildContext context, TObservable observable) {
    final contextFrame = _contextLastFrame[context];
    final observableFrame = _contextObservableLastFrame[context]?[observable];
    if (observableFrame == contextFrame) {
      // The observable was watch()'ed to during the last frame when the
      // context was rebuilt. Widget is still interested in the observable
      // changes.
      return true;
    }
    _contextObservableLastFrame[context]!.remove(observable);
    final subscription = _contextSubs[context]!.remove(observable)!;
    unwatch(context, observable, subscription);
    return false;
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _isFirstFrame = false);
    SchedulerBinding.instance.addPostFrameCallback(_onPostFrame);
  }

  void _onPostFrame(Duration frameTimestamp) {
    _currentFrame = frameTimestamp;
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback(_onPostFrame);
    }
  }

  @override
  void unmount() {
    final contextSubs = _contextSubs.keys.toList();
    for (final element in contextSubs) {
      _unsubscribe(element);
    }
    super.unmount();
  }

  void _unsubscribe(BuildContext context) {
    final observableSubs = _contextSubs[context];
    if (observableSubs == null) {
      return;
    }

    for (final observable in observableSubs.keys) {
      final subscription = observableSubs[observable]!;
      unwatch(context, observable, subscription);
    }
    _contextSubs.remove(context);
    _contextLastFrame.remove(context);
    _contextObservableLastFrame.remove(context);
  }

  void updateContextLastFrame(BuildContext context) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return;
    }
    _contextLastFrame[context] = _currentFrame;
  }

  TSubscription? subscribe(Element dependent, TObservable observable) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return null;
    }

    final subscription =
        _contextSubs.putIfAbsent(dependent, HashMap.new)[observable] ??=
            watch(dependent, observable, dependent.markNeedsBuild);

    _contextLastFrame[dependent] = _currentFrame;
    _contextObservableLastFrame.putIfAbsent(
        dependent, HashMap.new)[observable] = _currentFrame;

    return subscription;
  }
}
