import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef WatchSelector = Object? Function(Object? value);

abstract interface class ContextWatchSubscription {
  Object get observable;
  bool get hasValue;
  Object? get value;
  ContextWatchSelectorParameterType get selectorParameterType;

  void cancel();
}

enum ContextWatchSelectorParameterType {
  value,
  observable,
}

abstract class ContextWatcher<TObservable extends Object> {
  var _rebuildIfNeeded = InheritedContextWatchElement._neverRebuild;

  bool _canHandle(Object observable) => observable is TObservable;

  /// Triggers a rebuild of the [context] if it is interested in the [observable]
  /// value change notification.
  @protected
  @nonVirtual
  void rebuildIfNeeded(BuildContext context, Object observable) =>
      _rebuildIfNeeded(context, observable);

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
      watcher._rebuildIfNeeded = _rebuildIfNeeded;
    }
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _isFirstFrame = false);
    SchedulerBinding.instance.addPostFrameCallback(_onFrameEnd);
  }

  void _onFrameEnd(_) {
    for (final context in _potentiallyUnwatchedContexts) {
      _unwatchContext(context);
    }
    _potentiallyUnwatchedContexts.clear();

    SchedulerBinding.instance.addPostFrameCallback(_onFrameEnd);
  }

  /// Every time a [watch]'ed observable notifies of a change, the [context]
  /// which invoked the [watch] method will be added to this set and scheduled
  /// for rebuild. If after the frame is built, the [context] is not found in
  /// the set, it means that the [context] still watches some observables and
  /// should not be unwatched.
  final _potentiallyUnwatchedContexts = HashSet<BuildContext>.identity();

  bool _isFirstFrame = true;

  final _contextData = HashMap<BuildContext, _ContextData>.identity();

  /// This is used to keep track of the dependent [Element]s that have been
  /// deactivated in the current frame. We need to keep track of them to
  /// not dispose of the [ValueProvider]s too early, while the [Element] can
  /// still be reactivated in the same frame.
  final _deactivatedElements = HashSet<Element>.identity();

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
      watcher._rebuildIfNeeded = _neverRebuild;
    }
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._rebuildIfNeeded = _rebuildIfNeeded;
    }
  }

  /// Returns the [ContextWatchObservable] for the given [observable]
  /// within a [context] or `null` if called outside of the build phase.
  ///
  /// When called within a build phase, automatically creates a
  /// [ContextWatchSubscription].
  @nonVirtual
  ContextWatchObservable? getOrCreateObservable<T>(
    BuildContext context,
    Object observable,
  ) {
    final contextData = _fetchContextDataForWatch(context);
    if (contextData == null) {
      return null;
    }

    var observableData = contextData.observables[observable];
    if (observableData == null) {
      final subscription =
          _watcherFor(observable).createSubscription<T>(context, observable);
      observableData = ContextWatchObservable._(subscription);
      contextData.observables[observable] = observableData;
    }
    observableData._lastFrame = contextData.lastFrame;
    return observableData;
  }

  @pragma('vm:prefer-inline')
  ContextWatcher _watcherFor(Object observable) {
    final watchers = (widget as InheritedContextWatch).watchers;
    final length = watchers.length;
    for (var i = 0; i < length; i++) {
      final watcher = watchers[i];
      if (watcher._canHandle(observable)) {
        return watcher;
      }
    }
    throw UnsupportedError(
      'No ContextWatcher found for ${observable.runtimeType}',
    );
  }

  @nonVirtual
  void unwatchEffect(
    BuildContext context,
    Object observable,
    Object effectKey,
  ) {
    final contextData = _contextData[context];
    if (contextData == null) {
      return;
    }
    final observableData = contextData.observables[observable];
    if (observableData == null) {
      return;
    }
    observableData._unwatchEffect(effectKey);
  }

  _ContextData? _fetchContextDataForWatch(BuildContext context) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    // If [watch] is called, it means the element is active. If it was
    // previously deactivated - remove it from the list of deactivated
    // elements. This is important for handling the element re-parenting.
    _deactivatedElements.remove(context);

    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return null;
    }

    _potentiallyUnwatchedContexts.remove(context);

    final contextData = _contextData[context] ??= _ContextData();
    final frame = _currentFrameTimeStamp;

    if (contextData.lastFrame != frame) {
      // It's a new frame, so let's clear all selectors as they might've changed
      for (final observableData in contextData.observables.values) {
        observableData._prepareForRebuild();
      }
      contextData.lastFrame = frame;
    }
    return contextData;
  }

  @override
  void removeDependent(Element dependent) {
    // This method is called when the [dependent] is deactivated, but not
    // yet unmounted. The element can be reactivated during the same fame.
    // So, let's not dispose the context data immediately, but rather wait
    // until the end of the frame to see if the element is reactivated.
    _deactivatedElements.add(dependent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_deactivatedElements.contains(dependent)) {
        _unwatchContext(dependent);
        _deactivatedElements.remove(dependent);
      }
    });
    super.removeDependent(dependent);
  }

  @override
  void unmount() {
    _deactivatedElements.clear();
    for (final contextData in _contextData.values) {
      for (final observableData in contextData.observables.values) {
        observableData.subscription.cancel();
      }
    }
    _contextData.clear();
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._rebuildIfNeeded = _neverRebuild;
    }
    super.unmount();
  }

  static void _neverRebuild(BuildContext context, Object observable) {}

  void _rebuildIfNeeded(BuildContext context, Object observable) {
    if (!context.mounted) {
      _unwatchContext(context);
      return;
    }

    final contextData = _contextData[context];
    if (contextData == null) {
      _unwatchContext(context);
      return;
    }

    final observableData = contextData.observables[observable];
    if (observableData == null) {
      _unwatch(contextData, observable);
      return;
    }

    if (contextData.lastFrame != observableData._lastFrame) {
      _unwatch(contextData, observable);
      return;
    }

    final selectedValuesChanged = observableData._invokeEffectsAndSelectors();

    /// If either `watch()` was used during the last build, or the selected
    /// values changed, we need to rebuild
    if (observableData._isWatchedEntirely || selectedValuesChanged) {
      _scheduleRebuild(context as Element);
    }
  }

  @pragma('vm:prefer-inline')
  void _scheduleRebuild(Element element) {
    if (_isBuildPhase) {
      // If we are in the build phase, we can't rebuild immediately, because
      // it would break the build. Instead, we need to schedule a post-frame
      // callback to rebuild the context.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (element.mounted) {
          _doScheduleRebuild(element);
        }
      });
    } else {
      // If we are not in the build phase, we can rebuild immediately.
      _doScheduleRebuild(element);
    }
  }

  @pragma('vm:prefer-inline')
  void _doScheduleRebuild(Element element) {
    // Let's add the element to the list of potentially unwatched contexts,
    // so that we can unwatch it after the requested frame is built if
    // no `watch()` calls are detected.
    _potentiallyUnwatchedContexts.add(element);
    element.markNeedsBuild();
  }

  void _unwatch(
    _ContextData contextData,
    Object observable,
  ) {
    final observableData = contextData.observables.remove(observable);
    observableData?.subscription.cancel();
  }

  void _unwatchContext(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final observableData in contextData.observables.values) {
      observableData.subscription.cancel();
    }
  }
}

final class _ContextData {
  Duration lastFrame = const Duration(microseconds: -1);

  /// Observable -> ContextWatchObservable
  final observables = HashMap<Object, ContextWatchObservable>.identity();
}

final class ContextWatchObservable {
  ContextWatchObservable._(this.subscription);

  final ContextWatchSubscription subscription;

  Duration _lastFrame = const Duration(microseconds: -1);

  /// Whether the observable was watched for any possible change via [watch]
  bool _isWatchedEntirely = false;

  /// Contains (flattened) selectors and effects in the following format:
  ///   [0] bool: true if selector, false if effect
  ///   [1] Function: selector or effect
  ///   [2] Object?: selected value or effect key
  final _selectorsAndEffects = List<Object?>.empty(growable: true);

  /// Effect Key -> Effect state bitmask
  final _keyedEffectStates = HashMap<Object, int>();

  @pragma('vm:prefer-inline')
  void watch() {
    _isWatchedEntirely = true;
  }

  @pragma('vm:prefer-inline')
  void watchOnly(
    Function selector,
    Object? selectedValue,
  ) {
    final oldLength = _selectorsAndEffects.length;
    _selectorsAndEffects.length += 3;
    _selectorsAndEffects[oldLength] = true;
    _selectorsAndEffects[oldLength + 1] = selector;
    _selectorsAndEffects[oldLength + 2] = selectedValue;
  }

  @pragma('vm:prefer-inline')
  void watchEffect(
    Function effect, {
    required Object? key,
    required bool immediate,
    required bool once,
  }) {
    assert(
      !immediate || key != null,
      'watchEffect(immediate: true) requires a unique key',
    );
    assert(
      !once || key != null,
      'watchEffect(once: true) requires a unique key',
    );

    final oldLength = _selectorsAndEffects.length;
    _selectorsAndEffects.length += 3;
    _selectorsAndEffects[oldLength] = false;
    _selectorsAndEffects[oldLength + 1] = effect;
    _selectorsAndEffects[oldLength + 2] = key;

    if (key != null) {
      final effectBitmask = _keyedEffectStates[key];
      final shouldInvoke = immediate && effectBitmask == null;
      if (shouldInvoke) {
        switch (subscription.selectorParameterType) {
          case ContextWatchSelectorParameterType.value:
            assert(subscription.hasValue);
            effect(subscription.value);
          case ContextWatchSelectorParameterType.observable:
            effect(subscription.observable);
        }
      }
      _keyedEffectStates[key] = _effectBitmask(
        once: once,
        wasInvoked: shouldInvoke ||
            effectBitmask != null && _effectBitmaskWasInvoked(effectBitmask),
      );
    }
  }

  void _unwatchEffect(Object effectKey) {
    final length = _selectorsAndEffects.length;
    for (var i = 2; i < length; i += 3) {
      if (_selectorsAndEffects[i] == effectKey &&
          _selectorsAndEffects[i - 2] == false) {
        _selectorsAndEffects.removeRange(i - 2, i + 1);
        return;
      }
    }
  }

  @pragma('vm:prefer-inline')
  bool _invokeEffectsAndSelectors() {
    assert(
      subscription.selectorParameterType !=
              ContextWatchSelectorParameterType.value ||
          subscription.hasValue,
    );

    bool selectedValuesChanged = false;
    final length = _selectorsAndEffects.length;
    final callbackArg = switch (subscription.selectorParameterType) {
      ContextWatchSelectorParameterType.value => subscription.value,
      ContextWatchSelectorParameterType.observable => subscription.observable,
    };
    for (var i = 0; i < length; i += 3) {
      selectedValuesChanged = _invokeSelectorOrEffect(
            _selectorsAndEffects[i] as bool,
            _selectorsAndEffects[i + 1] as Function,
            _selectorsAndEffects[i + 2],
            callbackArg,
          ) ||
          selectedValuesChanged;
    }
    return selectedValuesChanged;
  }

  @pragma('vm:prefer-inline')
  bool _invokeSelectorOrEffect(
    bool isSelector,
    Function func,
    Object? selectedValueOrEffectKey,
    Object? arg,
  ) {
    if (isSelector) {
      final selectedValue = func(arg);
      return selectedValue != selectedValueOrEffectKey;
    }

    final effectKey = selectedValueOrEffectKey;
    if (effectKey == null) {
      func(arg);
      return false;
    }

    final effectBitmask = _keyedEffectStates[effectKey]!;
    final once = _effectBitmaskIsOnce(effectBitmask);
    final wasInvoked = _effectBitmaskWasInvoked(effectBitmask);
    if (once) {
      if (wasInvoked) {
        return false;
      }
      func(arg);
      _keyedEffectStates[effectKey] =
          _updateEffectBitmaskWithInvoked(effectBitmask);
      return false;
    }

    func(arg);
    if (!wasInvoked) {
      _keyedEffectStates[effectKey] =
          _updateEffectBitmaskWithInvoked(effectBitmask);
    }
    return false;
  }

  @pragma('vm:prefer-inline')
  void _prepareForRebuild() {
    _selectorsAndEffects.length = 0;
    _isWatchedEntirely = false;
  }
}

@pragma('vm:prefer-inline')
int _effectBitmask({
  required bool once,
  required bool wasInvoked,
}) {
  var bitmask = once ? 1 : 0;
  bitmask |= wasInvoked ? 2 : 0;
  return bitmask;
}

@pragma('vm:prefer-inline')
int _updateEffectBitmaskWithInvoked(int effectBitmask) => effectBitmask | 2;

@pragma('vm:prefer-inline')
bool _effectBitmaskIsOnce(int effectBitmask) => effectBitmask & 1 != 0;

@pragma('vm:prefer-inline')
bool _effectBitmaskWasInvoked(int effectBitmask) => effectBitmask & 2 != 0;
