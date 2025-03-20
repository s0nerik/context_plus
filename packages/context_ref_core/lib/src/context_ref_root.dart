import 'dart:collection';

import 'package:context_plus_build_context/context_plus_build_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'ref.dart';
import 'value_provider.dart';

class ContextRefRoot extends InheritedWidget {
  const ContextRefRoot({
    super.key,
    required super.child,
  });

  static InheritedContextRefElement of(BuildContext context) {
    if (context is ContextPlusElementProxy) {
      context = context.actualElement;
    }

    final element =
        context.getElementForInheritedWidgetOfExactType<ContextRefRoot>()
            as InheritedContextRefElement?;
    assert(
      element != null,
      'No ContextRef.root() found. Did you forget to add a ContextRef.root() widget?',
    );
    return element!;
  }

  @override
  InheritedContextRefElement createElement() =>
      InheritedContextRefElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

@internal
class InheritedContextRefElement extends InheritedElement {
  InheritedContextRefElement(super.widget) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _isFirstFrame = false);
  }

  bool _isFirstFrame = true;

  bool get _isBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        _isFirstFrame && phase == SchedulerPhase.idle;
  }

  final _refs = HashMap<Element, HashSet<ReadOnlyRef>>.identity();
  void _addRef(Element element, ReadOnlyRef ref) {
    final refs = _refs[element] ??= HashSet<ReadOnlyRef>.identity();
    refs.add(ref);
  }

  ValueProvider<T> bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() create,
    required void Function(T value)? dispose,
    required Object? key,
  }) {
    if (context is ContextPlusElementProxy) {
      context = context.actualElement;
    }

    assert(context is Element);
    assert(
      context.debugDoingBuild ||
          (context.widget is LayoutBuilder && _isBuildPhase),
      'Calling bind*() outside the build() method of a widget is not allowed.',
    );

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);
    _addRef(context as Element, ref);

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
          _scheduleRebuild(element);
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
    if (context is ContextPlusElementProxy) {
      context = context.actualElement;
    }

    assert(context is Element);
    assert(
      context.debugDoingBuild ||
          (context.widget is LayoutBuilder && _isBuildPhase),
      'Calling bind*() outside the build() method of a widget is not allowed.',
    );

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);
    _addRef(context as Element, ref);

    final provider = ref.getOrCreateProvider(context);
    provider.creator = null;
    provider.disposer = _noopDispose;
    if (provider.shouldUpdateValue(value)) {
      provider.value = value;
      for (final element in ref.dependents) {
        if (element.mounted) {
          _scheduleRebuild(element);
        }
      }
    }
    return provider;
  }

  T get<T>(BuildContext context, ReadOnlyRef<T> ref) {
    if (context is ContextPlusElementProxy) {
      context = context.actualElement;
    }

    assert(context is Element);

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);
    _addRef(context as Element, ref);

    ref.dependents.add(context);

    var provider =
        ref.dependentProvidersCache[context] ?? ref.providers[context];
    if (provider == null) {
      context.visitAncestorElements((element) {
        final p = ref.providers[element];
        if (p != null) {
          provider = p;
          ref.dependentProvidersCache[context as Element] = p;
          return false;
        }
        return true;
      });
    }
    assert(
      provider != null,
      '$ref is not bound. You probably forgot to call Ref.bind() on a parent context.',
    );

    return provider!.value;
  }

  @override
  void removeDependent(Element dependent) {
    // This method is called when the [dependent] is deactivated, but not
    // yet unmounted. The element can be reactivated during the same fame.
    // So, let's not dispose the context data immediately, but rather wait
    // until the end of the frame to see if the element is reactivated.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!dependent.mounted) {
        _disposeContextData(dependent);
      }
    });
    super.removeDependent(dependent);
  }

  void _disposeContextData(BuildContext context) {
    final refs = _refs.remove(context);
    for (final ref in refs ?? const <ReadOnlyRef>[]) {
      final provider = ref.providers.remove(context);
      if (provider != null) {
        _disposeProvider(provider);
      }
      ref.dependents.remove(context);
      ref.dependentProvidersCache.remove(context);
    }
  }

  @override
  void unmount() {
    for (final element in _refs.keys.toList(growable: false)) {
      _disposeContextData(element);
    }
    super.unmount();
  }
}

@pragma('vm:prefer-inline')
void _scheduleRebuild(Element element) {
  if (SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks) {
    // If we are in the persistent callbacks phase, we need to defer
    // the rebuild to the next frame to avoid calling setState() during
    // the build phase.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (element.mounted) {
        element.markNeedsBuild();
      }
    });
  } else {
    // Otherwise, we can rebuild immediately.
    element.markNeedsBuild();
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
