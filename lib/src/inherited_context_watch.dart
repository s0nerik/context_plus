import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
abstract class InheritedContextWatch<TObservable, TSubscription>
    extends InheritedWidget {
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
abstract class ObservableNotifierInheritedElement<TObservable, TSubscription>
    extends InheritedElement {
  ObservableNotifierInheritedElement(super.widget);

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
  TSubscription watch<T>(
    BuildContext context,
    TObservable observable,
  );

  @protected
  void unwatch(
    BuildContext context,
    TObservable observable,
  );

  @protected
  void unwatchContext(BuildContext context);

  @protected
  void unwatchAllContexts();

  @protected
  @useResult
  bool canNotify(BuildContext context, TObservable observable) {
    final contextFrame = _contextLastFrame[context];
    final observableFrame = _contextObservableLastFrame[context]?[observable];
    if (observableFrame == contextFrame && context.mounted) {
      // The observable was watch()'ed to during the last frame when the
      // context was rebuilt. Widget is still interested in the observable
      // changes.
      return true;
    }
    _contextObservableLastFrame[context]!.remove(observable);
    unwatch(context, observable);
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
  void removeDependent(Element dependent) {
    super.removeDependent(dependent);
    _unsubscribe(dependent);
  }

  @override
  void unmount() {
    unwatchAllContexts();
    super.unmount();
  }

  void _unsubscribe(BuildContext context) {
    unwatchContext(context);
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

  TSubscription? subscribe<T>(BuildContext context, TObservable observable) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return null;
    }

    _contextLastFrame[context] = _currentFrame;
    final lastFrameContextObservables =
        _contextObservableLastFrame[context] ??= HashMap.identity();
    lastFrameContextObservables[observable] = _currentFrame;

    return watch<T>(context, observable);
  }
}
