import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef WatchSelector = Object? Function(Object? value);

abstract interface class ContextWatchSubscription {
  Object? getData();
  void cancel();
}

abstract class ContextWatcher<TObservable extends Object> {
  var _shouldRebuild = _defaultShouldRebuild;

  bool _canHandle(Object observable) => observable is TObservable;

  @protected
  @useResult
  @nonVirtual
  bool shouldRebuild(
    BuildContext context,
    TObservable observable, {
    required Object? oldValue,
    required Object? newValue,
  }) =>
      _shouldRebuild(
        context,
        observable,
        oldValue: oldValue,
        newValue: newValue,
      );

  @protected
  @useResult
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    TObservable observable,
  );
}

class InheritedContextWatch extends InheritedWidget {
  const InheritedContextWatch({
    super.key,
    required this.watchers,
    required super.child,
  });

  final List<ContextWatcher> watchers;

  static InheritedContextWatchElement of(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<InheritedContextWatch>()
            as InheritedContextWatchElement?;
    assert(
      element != null,
      'No InheritedContextWatch found. Did you forget to add a ContextWatchRoot widget?',
    );
    return element!;
  }

  @override
  InheritedContextWatchElement createElement() =>
      InheritedContextWatchElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class InheritedContextWatchElement extends InheritedElement {
  InheritedContextWatchElement(super.widget) {
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._shouldRebuild = _shouldRebuild;
    }
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _isFirstFrame = false);
  }

  bool _isFirstFrame = true;

  final _contextData = HashMap<BuildContext, _ContextData>.identity();

  bool get _isBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        _isFirstFrame && phase == SchedulerPhase.idle;
  }

  @override
  void updated(covariant InheritedContextWatch oldWidget) {
    super.updated(oldWidget);
    for (final watcher in oldWidget.watchers) {
      watcher._shouldRebuild = _defaultShouldRebuild;
    }
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._shouldRebuild = _shouldRebuild;
    }
  }

  @nonVirtual
  Object? watch<T>(
    BuildContext context,
    Object observable, {
    dynamic selector,
  }) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return null;
    }

    final contextData = _contextData[context] ??= _ContextData();
    final frame = SchedulerBinding.instance.currentFrameTimeStamp;

    if (contextData.lastFrame != frame) {
      // It's a new frame, so let's clear all selectors as they might've changed
      contextData.observableSelectors.clear();
    }

    contextData.lastFrame = frame;
    contextData.observableLastFrame[observable] = frame;

    if (selector != null) {
      final selectors = contextData.observableSelectors[observable] ??= {};
      selectors.add(selector);
    }

    final existingSubscription =
        contextData.observableSubscriptions[observable];
    if (existingSubscription != null) {
      return existingSubscription.getData();
    }

    final watcher = (super.widget as InheritedContextWatch)
        .watchers
        .firstWhere((element) => element._canHandle(observable), orElse: () {
      throw StateError('No ContextWatcher found for ${observable.runtimeType}');
    });
    final subscription = watcher.createSubscription<T>(context, observable);
    contextData.observableSubscriptions[observable] = subscription;
    return subscription.getData();
  }

  @nonVirtual
  void updateContextLastFrame(BuildContext context) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return;
    }

    final contextData = _contextData[context] ??= _ContextData();
    contextData.lastFrame = SchedulerBinding.instance.currentFrameTimeStamp;
  }

  @override
  void removeDependent(Element dependent) {
    _unwatchContext(dependent);
    super.removeDependent(dependent);
  }

  @override
  void unmount() {
    for (final contextData in _contextData.values) {
      for (final subscription in contextData.observableSubscriptions.values) {
        subscription.cancel();
      }
    }
    _contextData.clear();
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._shouldRebuild = _defaultShouldRebuild;
    }
    super.unmount();
  }

  bool _shouldRebuild(
    BuildContext context,
    Object observable, {
    required Object? oldValue,
    required Object? newValue,
  }) {
    final contextData = _contextData[context];
    if (contextData == null) {
      _unwatch(context, observable);
      return false;
    }

    final contextLastFrame = contextData.lastFrame;
    final observableLastFrame = contextData.observableLastFrame[observable];
    if (observableLastFrame != contextLastFrame || !context.mounted) {
      _unwatch(context, observable);
      return false;
    }

    final selectors = contextData.observableSelectors[observable];
    if (selectors != null && selectors.isNotEmpty) {
      for (final selector in selectors) {
        if (!_isSameValue(
          oldValue: oldValue,
          newValue: newValue,
          selector: selector,
        )) {
          return true;
        }
      }
      return false;
    }

    return true;
  }

  void _unwatch(
    BuildContext context,
    Object observable,
  ) {
    final contextData = _contextData[context];
    if (contextData == null) {
      return;
    }

    final subscription = contextData.observableSubscriptions.remove(observable);
    subscription?.cancel();
  }

  void _unwatchContext(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final subscription in contextData.observableSubscriptions.values) {
      subscription.cancel();
    }
  }
}

class _ContextData {
  Duration? lastFrame;
  final observableLastFrame = HashMap<Object, Duration>.identity();
  final observableSubscriptions =
      HashMap<Object, ContextWatchSubscription>.identity();
  final observableSelectors =
      // Observable -> {Object? Function(Object?)}
      HashMap<Object, Set<dynamic>>.identity();
}

bool _defaultShouldRebuild(
  BuildContext context,
  Object observable, {
  required Object? oldValue,
  required Object? newValue,
}) =>
    false;

bool _isSameValue({
  required Object? oldValue,
  required Object? newValue,
  required dynamic selector,
}) {
  if (oldValue == null) {
    return newValue == null;
  }
  return selector(oldValue) == selector(newValue);
}
