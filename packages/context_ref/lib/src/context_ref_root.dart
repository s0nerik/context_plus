import 'dart:collection';

import 'package:context_plus_core/context_plus_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'ref.dart';
import 'value_provider.dart';

@internal
class ContextRefRoot extends StatelessWidget {
  const ContextRefRoot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (ElementDataHolder.maybeOf(context) == null) {
      return ElementDataHolder.scope(
        child: InheritedContextRefRoot(child: child),
      );
    }
    return InheritedContextRefRoot(child: child);
  }

  static InheritedContextRefElement of(BuildContext context) {
    final element =
        context
                .getElementForInheritedWidgetOfExactType<
                  InheritedContextRefRoot
                >()
            as InheritedContextRefElement?;
    assert(
      element != null,
      'No ContextRef.root() found. Did you forget to add a ContextRef.root() widget?',
    );
    return element!;
  }
}

@internal
class InheritedContextRefRoot extends InheritedWidget {
  const InheritedContextRefRoot({super.key, required super.child});

  @override
  InheritedContextRefElement createElement() =>
      InheritedContextRefElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

@internal
class InheritedContextRefElement extends InheritedElement {
  InheritedContextRefElement(super.widget) {
    ContextPlusFrameInfo.ensureFrameTracking();
    ContextPlusFrameInfo.registerPostFrameCallback(_onPostFrame);
  }

  late ElementDataHolder _dataHolder;

  final _hooksUsedLastFrame = HashSet<ElementHooks>();
  void _onPostFrame() {
    for (final hooks in _hooksUsedLastFrame) {
      hooks._onPostFrame();
    }
    _hooksUsedLastFrame.clear();
  }

  @override
  void rebuild({bool force = false}) {
    _dataHolder = ElementDataHolder.of(this);
    super.rebuild(force: force);
  }

  final _debugFrameBindingsByContext = Expando<HashMap<Ref, int>>(
    'debugFrameBindings',
  );

  bool _debugEnsureNoRebinds(BuildContext context, Ref ref) {
    final bindingsForContext =
        _debugFrameBindingsByContext[context] ??= HashMap<Ref, int>.identity();
    final frameIdWhenLastBound = bindingsForContext[ref];

    final currentFrame = ContextPlusFrameInfo.currentFrameId;

    bool currentBindIsNewInThisFrame;
    if (frameIdWhenLastBound == currentFrame) {
      currentBindIsNewInThisFrame = false; // Duplicate in this frame
    } else {
      currentBindIsNewInThisFrame = true; // New in this frame (or first time)
      bindingsForContext[ref] = currentFrame; // Record it for this frame
    }
    return currentBindIsNewInThisFrame;
  }

  _RefElementData _getOrCreateElementData(Element element) {
    final container = _dataHolder.getContainer(element);
    var data = container.get<_RefElementData>();
    data ??= container.set(_RefElementData(element: element));
    return data;
  }

  ValueProvider<T> bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() create,
    required void Function(T value)? dispose,
    required Object? key,
    bool allowRebind = false,
  }) {
    assert(context is Element);
    assert(
      context.debugDoingBuild ||
          (context.widget is LayoutBuilder &&
              ContextPlusFrameInfo.isBuildPhase),
      'Calling bind*() outside the build() method of a widget is not allowed.',
    );
    assert(
      _debugEnsureNoRebinds(context, ref) || allowRebind,
      'Ref may not be bound to the same BuildContext more than once in a single build()',
    );

    _getOrCreateElementData(context as Element).addProvidedRef(ref);

    final provider = ref.getOrCreateProvider(context);
    final didChangeKey = !_isSameKey(provider.key, key);
    if (didChangeKey) {
      _disposeProvider(provider);
      provider.key = key;
    }
    provider.creator = create;
    provider.disposer = dispose;
    if (didChangeKey) {
      for (final element in ref.dependents) {
        if (element.mounted) {
          _dataHolder.scheduleRebuild(element);
        }
      }
    }
    return provider;
  }

  ValueProvider<T> bindValue<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T value,
  }) {
    assert(context is Element);
    assert(
      context.debugDoingBuild ||
          (context.widget is LayoutBuilder &&
              ContextPlusFrameInfo.isBuildPhase),
      'Calling bind*() outside the build() method of a widget is not allowed.',
    );
    _getOrCreateElementData(context as Element).addProvidedRef(ref);

    final provider = ref.getOrCreateProvider(context);
    provider.creator = null;
    provider.disposer = _noopDispose;
    if (provider.shouldUpdateValue(value)) {
      provider.value = value;
      for (final element in ref.dependents) {
        if (element.mounted) {
          _dataHolder.scheduleRebuild(element);
        }
      }
    }
    return provider;
  }

  ValueProvider<T>? get<T>(BuildContext context, ReadOnlyRef<T> ref) {
    assert(context is Element);
    final elementData =
        _dataHolder.getContainer(context as Element).get<_RefElementData>();

    ref.dependents.add(context);

    if (ref.providers.isEmpty) {
      return null;
    }

    if (ref.dependentProvidersCache.containsKey(context)) {
      return ref.dependentProvidersCache[context];
    }

    if (ref.providers.containsKey(context)) {
      return ref.providers[context];
    }

    ValueProvider<T>? provider;
    context.visitAncestorElements((element) {
      final p = ref.providers[element];
      if (p != null) {
        provider = p;
        ref.dependentProvidersCache[context] = p;
        return false;
      }
      return true;
    });
    if (provider != null) {
      return provider;
    }

    final inheritedElement = elementData?.inheritedElement?.target;
    if (inheritedElement != null) {
      return get<T>(inheritedElement, ref);
    }

    ref.dependentProvidersCache[context] = null;
    return provider;
  }

  ElementHooks hooks(BuildContext context) {
    final hooks = _getOrCreateElementData(context as Element).hooks;
    _hooksUsedLastFrame.add(hooks);
    return hooks;
  }

  void setInheritedElement(Element element, Element inheritedElement) {
    _getOrCreateElementData(element).inheritedElement = WeakReference<Element>(
      inheritedElement,
    );
  }

  @override
  void unmount() {
    ContextPlusFrameInfo.unregisterPostFrameCallback(_onPostFrame);
    super.unmount();
  }
}

class _RefElementData implements ElementData {
  _RefElementData({required this.element});

  final Element element;

  WeakReference<Element>? inheritedElement;

  HashSet<ReadOnlyRef>? _providedRefs;
  Set<ReadOnlyRef> get providedRefs => _providedRefs ?? const <ReadOnlyRef>{};
  void addProvidedRef(ReadOnlyRef ref) {
    _providedRefs ??= HashSet<ReadOnlyRef>.identity();
    _providedRefs!.add(ref);
  }

  ElementHooks? _hooks;
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  ElementHooks get hooks => _hooks ??= ElementHooks();

  @override
  void dispose() {
    for (final ref in _providedRefs ?? const <ReadOnlyRef>{}) {
      final provider = ref.providers.remove(element);
      if (provider != null) {
        _disposeProvider(provider);
      }
      ref.dependents.remove(element);
      ref.dependentProvidersCache.remove(element);
    }
    _hooks?._dispose();
  }
}

@internal
typedef ElementHookKey = (Type, Ref?, Object? /* key */);

@internal
class ElementHooks {
  static ElementHookKey _key<T>({Object? key, Ref? ref}) {
    if (ref != null) {
      if (key != null) return (T, ref, key);
      return (T, ref, null);
    }
    if (key != null) return (T, null, key);
    return (T, null, null);
  }

  final _providers = HashMap<ElementHookKey, ValueProvider>();

  var _isDisposed = false;
  final _keysUsedLastFrame = HashSet<ElementHookKey>();

  // Cache the callback closure to avoid re-creating it each frame.
  void _onPostFrame() {
    if (_isDisposed) return;

    // Empty `_keysUsedLastFrame` means that `context.use()` was never called on this
    // `BuildContext` in the last frame.
    //
    // This may happen if either:
    // - All `context.use()` calls got removed from the build method during the last frame.
    // - The `BuildContext` wasn't rebuilt during the last frame.
    if (_keysUsedLastFrame.isNotEmpty &&
        _keysUsedLastFrame.length < _providers.length) {
      final keysToDispose = <ElementHookKey>{};
      for (final key in _providers.keys) {
        if (!_keysUsedLastFrame.contains(key)) {
          keysToDispose.add(key);
        }
      }
      for (final key in keysToDispose) {
        final provider = _providers.remove(key);
        provider!.dispose();
      }
    }
    _keysUsedLastFrame.clear();
  }

  T use<T>({
    required BuildContext context,
    required T Function() create,
    required void Function(T value)? dispose,
    required Ref<T>? ref,
    required Object? key,
  }) {
    final providerKey = _key<T>(key: key, ref: ref);
    assert(
      !_keysUsedLastFrame.contains(providerKey),
      'Each context.use() call for a given BuildContext must have a different combination of return type, `key` and `ref` parameters. See https://pub.dev/packages/context_ref#use-parameter-combinations for more details.',
    );
    _keysUsedLastFrame.add(providerKey);

    var provider = _providers[providerKey] as ValueProvider<T>?;
    if (provider != null) {
      return provider.value;
    }

    provider =
        _providers[providerKey] =
            ValueProvider<T>()
              ..creator = create
              ..disposer = dispose;

    final value = provider.value;
    if (ref != null) {
      ref.bindValue(context, value);
    }
    return value;
  }

  void _dispose() {
    _isDisposed = true;
    _providers.forEach((_, provider) => _disposeProvider(provider));
  }
}

void _disposeProvider<T>(ValueProvider<T> provider) {
  if (!kDebugMode) {
    provider.dispose();
    return;
  }

  try {
    provider.dispose();
  } catch (e) {
    if (e.runtimeType.toString() != '_CompileTimeError') {
      // This happens during hot reload if the provided type has been renamed.
      rethrow;
    }
  }
}

void _noopDispose(_) {}

bool _isSameKey(Object? key1, Object? key2) {
  if (key1 == key2) {
    return true;
  }
  return switch (key1) {
    List() => key2 is List && listEquals(key1, key2),
    Set() => key2 is Set && setEquals(key1, key2),
    Map() => key2 is Map && mapEquals(key1, key2),
    _ => false,
  };
}
