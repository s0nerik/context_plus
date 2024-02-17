import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef WatchSelector = Object? Function(Object? value);

abstract interface class ContextWatchSubscription {
  void cancel();
}

abstract class ContextWatcher<TObservable extends Object> {
  var _shouldRebuild = InheritedContextWatchElement._neverRebuild;
  var _getObservableSelection =
      InheritedContextWatchElement._noObservableSelection;

  bool _canHandle(Object observable) => observable is TObservable;

  /// Returns whether the widget should rebuild when the [observable] changes
  /// based on the [oldValue] and [newValue].
  ///
  /// Call this method to determine if the widget should rebuild for the
  /// observable types that store current state.
  ///
  /// Must not be used together with [getObservableSelection].
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

  /// Returns a list of selected values from [observable] that should be used
  /// to determine if the widget should rebuild.
  ///
  /// Call this method to determine if the widget should rebuild for the
  /// observable types that do_not store current state.
  ///
  /// Must not be used together with [shouldRebuild].
  @protected
  @useResult
  @nonVirtual
  List<Object?>? getObservableSelection(
    BuildContext context,
    TObservable observable,
  ) =>
      _getObservableSelection(context, observable);

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
      watcher._getObservableSelection = _getObservableSelection;
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

  Duration get _currentFrameTimeStamp {
    if (_isFirstFrame) {
      return Duration.zero;
    }
    return SchedulerBinding.instance.currentFrameTimeStamp;
  }

  @override
  void updated(covariant InheritedContextWatch oldWidget) {
    super.updated(oldWidget);
    for (final watcher in oldWidget.watchers) {
      watcher._shouldRebuild = _neverRebuild;
      watcher._getObservableSelection = _noObservableSelection;
    }
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._shouldRebuild = _shouldRebuild;
      watcher._getObservableSelection = _getObservableSelection;
    }
  }

  @nonVirtual
  ContextWatchSubscription? watch<T>(
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
    final frame = _currentFrameTimeStamp;

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
      return existingSubscription;
    }

    final watcher = (super.widget as InheritedContextWatch)
        .watchers
        .firstWhere((element) => element._canHandle(observable), orElse: () {
      throw UnsupportedError(
        'No ContextWatcher found for ${observable.runtimeType}',
      );
    });
    final subscription = watcher.createSubscription<T>(context, observable);
    contextData.observableSubscriptions[observable] = subscription;
    return subscription;
  }

  @nonVirtual
  void updateContextLastFrame(BuildContext context) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return;
    }

    final contextData = _contextData[context] ??= _ContextData();
    contextData.lastFrame = _currentFrameTimeStamp;
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
      watcher._shouldRebuild = _neverRebuild;
    }
    super.unmount();
  }

  static bool _neverRebuild(
    BuildContext context,
    Object observable, {
    required Object? oldValue,
    required Object? newValue,
  }) =>
      false;

  bool _shouldRebuild(
    BuildContext context,
    Object observable, {
    required Object? oldValue,
    required Object? newValue,
  }) {
    if (!context.mounted) {
      _unwatch(context, observable);
      return false;
    }

    final contextData = _contextData[context];
    if (contextData == null) {
      _unwatch(context, observable);
      return false;
    }

    final contextLastFrame = contextData.lastFrame;
    final observableLastFrame = contextData.observableLastFrame[observable];
    if (observableLastFrame != contextLastFrame) {
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

  static List<Object?>? _noObservableSelection(
    BuildContext context,
    Object observable,
  ) =>
      null;

  List<Object?>? _getObservableSelection(
    BuildContext context,
    Object observable,
  ) {
    if (!context.mounted) {
      _unwatch(context, observable);
      return null;
    }

    final contextData = _contextData[context];
    if (contextData == null) {
      _unwatch(context, observable);
      return null;
    }

    final contextLastFrame = contextData.lastFrame;
    final observableLastFrame = contextData.observableLastFrame[observable];
    if (observableLastFrame != contextLastFrame) {
      _unwatch(context, observable);
      return null;
    }

    final selectors = contextData.observableSelectors[observable];
    if (selectors == null || selectors.isEmpty) {
      return null;
    }

    final selection = <Object?>[
      for (final selector in selectors)
        _selectValue(
          value: observable,
          selector: selector,
        ),
    ];
    return selection;
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

dynamic _selectValue({
  required Object? value,
  required dynamic selector,
}) {
  if (value == null) {
    return null;
  }
  return selector(value);
}
