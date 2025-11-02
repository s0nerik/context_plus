import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'context_plus_frame_info.dart';

extension type ElementDataHolder(_InheritedElementDataHolderElement _holder) {
  /// Gets or creates a new [ElementDataContainer] for the given [dependent] element.
  /// Adds the [dependent] element as a dependent of [_InheritedElementDataHolderElement].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  ElementDataContainer getContainer(Element dependent) =>
      _holder.getOrCreateContainer(dependent);

  /// Gets existing [ElementDataContainer] for the given [dependent] element.
  /// DOES NOT add the [dependent] element as a dependent of [_InheritedElementDataHolderElement].
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  ElementDataContainer? getContainerIfExists(Element dependent) =>
      _holder.getContainerIfExists(dependent);

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void disposeContainerIfExists(Element dependent) =>
      _holder.disposeContainerIfExists(dependent);

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void scheduleRebuild(Element element) => _holder.scheduleRebuild(element);

  static Widget scope({Key? key, required Widget child}) =>
      _InheritedElementDataHolder(key: key, child: child);

  static ElementDataHolder? maybeOf(BuildContext context) {
    final element =
        context
            .getElementForInheritedWidgetOfExactType<
              _InheritedElementDataHolder
            >();
    return element != null
        ? ElementDataHolder(element as _InheritedElementDataHolderElement)
        : null;
  }

  static ElementDataHolder of(BuildContext context) {
    final holder = maybeOf(context);
    assert(
      holder != null,
      'No ElementDataHolder found. Did you forget to add a `ContextPlus.root()` (or `ContextWatch.root()`/`ContextRef.root()`) widget?',
    );
    return holder!;
  }
}

abstract interface class ElementData {
  void dispose();
}

final class ElementDataContainer {
  late int _lastFrameId;
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  int get lastFrameId => _lastFrameId;

  final _data = HashMap<Type, ElementData>.identity();
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  T? get<T extends ElementData>() => _data[T] as T?;
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  T set<T extends ElementData>(T value) => _data[T] = value;

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void dispose() {
    for (final data in _data.values) {
      data.dispose();
    }
  }
}

class _InheritedElementDataHolder extends InheritedWidget {
  const _InheritedElementDataHolder({super.key, required super.child});

  @override
  _InheritedElementDataHolderElement createElement() =>
      _InheritedElementDataHolderElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

final class _InheritedElementDataHolderElement extends InheritedElement {
  _InheritedElementDataHolderElement(super.widget) {
    ContextPlusFrameInfo.ensureFrameTracking();
    ContextPlusFrameInfo.registerPostFrameCallback(_onPostFrame);
  }

  static const _flagShouldMarkNeedsBuild = 1 << 0;
  static const _flagDidMarkNeedsBuild = 1 << 1;
  static const _flagDidDeactivate = 1 << 2;

  var _flaggedElements = HashMap<Element, int>();
  final _dataContainers = Expando<ElementDataContainer>();

  void _onPostFrame() {
    if (!mounted) {
      ContextPlusFrameInfo.unregisterPostFrameCallback(_onPostFrame);
      _flaggedElements.forEach((element, flags) {
        final container = _dataContainers[element];
        if (container != null && !element.mounted) {
          container.dispose();
          _dataContainers[element] = null;
        }
      });
      return;
    }

    final nextFlaggedElements = HashMap<Element, int>();
    _flaggedElements.forEach((element, flags) {
      final container = _dataContainers[element]!;
      if (!element.mounted) {
        container.dispose();
        _dataContainers[element] = null;
        return;
      }

      if (flags & _flagDidMarkNeedsBuild != 0 &&
          container._lastFrameId != ContextPlusFrameInfo.currentFrameId) {
        container.dispose();
        _dataContainers[element] = null;
        return;
      }

      if (flags & _flagShouldMarkNeedsBuild != 0) {
        element.markNeedsBuild();
        nextFlaggedElements[element] = _flagDidMarkNeedsBuild;
      }
    });
    _flaggedElements = nextFlaggedElements;
  }

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  ElementDataContainer getOrCreateContainer(Element dependent) {
    dependent.dependOnInheritedElement(this);
    final container = _dataContainers[dependent] ??= ElementDataContainer();
    container._lastFrameId = ContextPlusFrameInfo.currentFrameId;
    return container;
  }

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  ElementDataContainer? getContainerIfExists(Element dependent) =>
      _dataContainers[dependent];

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void disposeContainerIfExists(Element dependent) {
    _dataContainers[dependent]?.dispose();
    _dataContainers[dependent] = null;
  }

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void scheduleRebuild(Element element) {
    if (ContextPlusFrameInfo.isBuildPhase) {
      _flaggedElements[element] =
          _flaggedElements[element] ?? 0 | _flagShouldMarkNeedsBuild;
    } else {
      // If we are not in the build phase, we can rebuild immediately.
      element.markNeedsBuild();
      _flaggedElements[element] =
          _flaggedElements[element] ?? 0 | _flagDidMarkNeedsBuild;
    }
  }

  @override
  void setDependencies(Element dependent, Object? value) {
    // Do nothing. We don't need the built-in _dependents map for this to work.
  }

  @override
  void removeDependent(Element dependent) {
    // This method is called when the [dependent] is deactivated, but not
    // yet unmounted. The element can be reactivated during the same fame.
    // So, let's not dispose the context data immediately, but rather wait
    // until the end of the frame to see if the element is reactivated.
    _flaggedElements[dependent] =
        _flaggedElements[dependent] ?? 0 | _flagDidDeactivate;
    super.removeDependent(dependent);
  }
}
