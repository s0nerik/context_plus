import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'value_provider.dart';
import 'ref.dart';

class ContextRefRoot extends InheritedWidget {
  const ContextRefRoot({
    super.key,
    required super.child,
  });

  static InheritedContextRefElement of(BuildContext context) {
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

class InheritedContextRefElement extends InheritedElement {
  InheritedContextRefElement(super.widget);

  final _contextData = HashMap<BuildContext, _ContextData>.identity();
  final _refDependentElements =
      // Ref -> {Element}
      HashMap<ReadOnlyRef, HashSet<Element>>.identity();

  ValueProvider<T>? _getProvider<T>(BuildContext context, ReadOnlyRef<T> ref) {
    final contextData = _contextData[context];
    if (contextData == null) {
      return null;
    }
    return contextData.providers[ref] as ValueProvider<T>?;
  }

  ValueProvider<T> _getOrCreateProvider<T>(BuildContext context, Ref<T> ref) {
    final contextData = _contextData[context] ??= _ContextData();
    return (contextData.providers[ref] ??= ValueProvider<T>())
        as ValueProvider<T>;
  }

  HashSet<Element> _getRefDependentElements(ReadOnlyRef ref) =>
      _refDependentElements[ref] ??= HashSet<Element>.identity();

  ValueProvider<T> bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() create,
    required void Function(T value)? dispose,
    required Object? key,
  }) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final provider = _getOrCreateProvider(context, ref);
    provider.key = key;
    provider.creator = create;
    provider.disposer = dispose;
    return provider;
  }

  ValueProvider<T> bindValue<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T value,
  }) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final provider = _getOrCreateProvider(context, ref);
    provider.creator = null;
    provider.disposer = _noopDispose;
    if (provider.shouldUpdateValue(value)) {
      provider.value = value;
      final dependentElements = _getRefDependentElements(ref);
      for (final element in dependentElements) {
        if (element.mounted) {
          element.markNeedsBuild();
        }
      }
    }
    return provider;
  }

  T get<T>(BuildContext context, ReadOnlyRef<T> ref) {
    assert(context is Element);

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final dependentElements = _getRefDependentElements(ref);
    dependentElements.add(context as Element);

    var provider = _getProvider<T>(context, ref);
    if (provider != null) {
      return provider.value;
    }

    context.visitAncestorElements((element) {
      final p = _contextData[element]?.providers[ref];
      if (p != null) {
        provider = p as ValueProvider<T>;
        return false;
      }
      return true;
    });

    assert(
      provider != null,
      '$ref is not bound. You probably forgot to call Ref.bind() on a parent context.',
    );

    return provider!.value;
  }

  @override
  void removeDependent(Element dependent) {
    _disposeDependentContextData(dependent);
    super.removeDependent(dependent);
  }

  void _disposeDependentContextData(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final provider in contextData.providers.values) {
      _disposeProvider(provider);
    }
    for (final ref in contextData.dependencies) {
      final dependentElements = _getRefDependentElements(ref);
      dependentElements.remove(context);
    }
  }

  @override
  void unmount() {
    for (final contextData in _contextData.values) {
      for (final provider in contextData.providers.values) {
        provider.dispose();
      }
    }
    _contextData.clear();
    super.unmount();
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

class _ContextData {
  final providers = HashMap<ReadOnlyRef, ValueProvider>.identity();
  final dependencies = HashSet<ReadOnlyRef>.identity();
}

void _noopDispose(_) {}
