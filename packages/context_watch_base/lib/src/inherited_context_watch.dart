import 'dart:collection';

import 'package:context_plus_core/context_plus_core.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'context_watcher.dart';

class InheritedContextWatch extends InheritedWidget {
  const InheritedContextWatch({
    super.key,
    required this.watchers,
    required super.child,
  });

  final List<ContextWatcher?> watchers;

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
      watcher?.rebuildCallback = _rebuildIfNeeded;
    }
  }

  late ElementDataHolder _dataHolder;

  @override
  void rebuild({bool force = false}) {
    _dataHolder = ElementDataHolder.of(this);
    super.rebuild(force: force);
  }

  @override
  void updated(covariant InheritedContextWatch oldWidget) {
    super.updated(oldWidget);
    for (final watcher in oldWidget.watchers) {
      watcher?.rebuildCallback = InternalContextWatcherAPI.neverRebuild;
    }
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher?.rebuildCallback = _rebuildIfNeeded;
    }
  }

  _ContextData _getOrCreateContextData(Element element) {
    final container = _dataHolder.getContainer(element);
    var contextData = container.get<_ContextData>();
    contextData ??= container.set(_ContextData());
    return contextData;
  }

  /// Returns the [ContextWatchObservable] for the given [observable]
  /// within a [context] or `null` if called outside of the build phase.
  ///
  /// When called within a build phase, automatically creates a
  /// [ContextWatchSubscription].
  @nonVirtual
  ContextWatchObservable getOrCreateObservable<T>(
    BuildContext context,
    Object observable,
    ContextWatcherObservableType type,
  ) {
    assert(
      context.debugDoingBuild ||
          (context.widget is LayoutBuilder &&
              ContextPlusFrameInfo.isBuildPhase),
      'Calling watch*() outside the build() method of a widget is not allowed.',
    );

    final contextData = _getOrCreateContextData(context as Element);
    if (contextData.lastFrameId != ContextPlusFrameInfo.currentFrameId) {
      // It's a new frame, so let's clear all selectors as they might've changed
      for (final observableData in contextData.observables.values) {
        observableData._prepareForRebuild();
      }
      contextData.lastFrameId = ContextPlusFrameInfo.currentFrameId;
    }

    var observableData = contextData.observables[observable];
    if (observableData == null) {
      final watcher = (widget as InheritedContextWatch).watchers[type.index];
      assert(watcher != null, 'No ContextWatcher found for ${type.name}');
      final subscription = watcher!.createSubscription<T>(context, observable);
      observableData = ContextWatchObservable._(subscription);
      contextData.observables[observable] = observableData;
    }
    observableData.lastFrameId = ContextPlusFrameInfo.currentFrameId;
    return observableData;
  }

  @nonVirtual
  void unwatchEffect(
    BuildContext context,
    Object observable,
    Object effectKey,
  ) {
    final contextData = _getOrCreateContextData(context as Element);
    contextData.observables[observable]?._unwatchEffect(effectKey);
  }

  @override
  void unmount() {
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher?.rebuildCallback = InternalContextWatcherAPI.neverRebuild;
    }
    super.unmount();
  }

  void _rebuildIfNeeded(BuildContext context, Object observable) {
    final contextDataContainer = _dataHolder.getContainerIfExists(
      context as Element,
    );
    if (contextDataContainer == null) {
      return;
    }

    final contextData = contextDataContainer.get<_ContextData>();
    if (contextData == null) {
      return;
    }

    final observableData = contextData.observables[observable];
    if (observableData == null) {
      return;
    }

    if (contextData.lastFrameId != observableData.lastFrameId) {
      contextData.unwatch(observable);
      return;
    }

    final selectedValuesChanged = observableData._invokeEffectsAndSelectors();

    /// If either `watch()` was used during the last build, or the selected
    /// values changed, we need to rebuild
    if (observableData._isWatchedEntirely || selectedValuesChanged) {
      _dataHolder.scheduleRebuild(context);
    }
  }
}

final class _ContextData implements ElementData {
  int lastFrameId = ContextPlusFrameInfo.currentFrameId;

  /// Observable -> ContextWatchObservable
  final observables = HashMap<Object, ContextWatchObservable>.identity();

  void unwatch(Object observable) {
    final observableData = observables.remove(observable);
    observableData?.subscription.cancel();
  }

  @override
  void dispose() {
    for (final observableData in observables.values) {
      observableData.subscription.cancel();
    }
  }
}

final class ContextWatchObservable {
  ContextWatchObservable._(this.subscription);

  final ContextWatchSubscription subscription;

  late int lastFrameId;

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
  bool wasEffectInvoked(Object key) {
    final effectBitmask = _keyedEffectStates[key];
    if (effectBitmask == null) {
      return false;
    }
    return _effectBitmaskWasInvoked(effectBitmask);
  }

  @pragma('vm:prefer-inline')
  void watch() {
    _isWatchedEntirely = true;
  }

  @pragma('vm:prefer-inline')
  void watchOnly(Function selector, Object? selectedValue) {
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
        effect(subscription.callbackArgument);
      }
      _keyedEffectStates[key] = _effectBitmask(
        once: once,
        wasInvoked:
            shouldInvoke ||
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
    bool selectedValuesChanged = false;
    final length = _selectorsAndEffects.length;
    final callbackArg = subscription.callbackArgument;
    for (var i = 0; i < length; i += 3) {
      selectedValuesChanged =
          _invokeSelectorOrEffect(
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
      _keyedEffectStates[effectKey] = _updateEffectBitmaskWithInvoked(
        effectBitmask,
      );
      return false;
    }

    func(arg);
    if (!wasInvoked) {
      _keyedEffectStates[effectKey] = _updateEffectBitmaskWithInvoked(
        effectBitmask,
      );
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
int _effectBitmask({required bool once, required bool wasInvoked}) {
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
