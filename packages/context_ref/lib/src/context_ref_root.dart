import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'value_provider.dart';
import 'ref.dart';

@internal
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

@internal
class InheritedContextRefElement extends InheritedElement {
  InheritedContextRefElement(super.widget);

  final _elementRefProviders =
      HashMap<Element, HashMap<ReadOnlyRef, ValueProvider>>.identity();
  final _elementDependencyRefs =
      HashMap<Element, HashSet<ReadOnlyRef>>.identity();
  final _refDependentElements =
      HashMap<ReadOnlyRef, HashSet<Element>>.identity();

  ValueProvider<T>? _getProvider<T>(Element element, ReadOnlyRef<T> ref) =>
      _elementRefProviders[element]?[ref] as ValueProvider<T>?;

  ValueProvider<T> _getOrCreateProvider<T>(Element element, Ref<T> ref) {
    final contextProviders =
        _elementRefProviders[element] ??= HashMap.identity();
    final provider = contextProviders[ref] ??= ValueProvider<T>();
    return provider as ValueProvider<T>;
  }

  HashSet<Element> _getOrCreateRefDependentElements(ReadOnlyRef ref) =>
      _refDependentElements[ref] ??= HashSet.identity();

  ValueProvider<T> bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() create,
    required void Function(T value)? dispose,
    required Object? key,
  }) {
    assert(context is Element);

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final provider = _getOrCreateProvider(context as Element, ref);
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
    assert(context is Element);

    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final provider = _getOrCreateProvider(context as Element, ref);
    provider.creator = null;
    provider.disposer = _noopDispose;
    if (provider.shouldUpdateValue(value)) {
      provider.value = value;
      final dependentElements = _getOrCreateRefDependentElements(ref);
      for (final element in dependentElements) {
        if (element.mounted) {
          scheduleMicrotask(element.markNeedsBuild);
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

    _refDependentElements[ref]?.add(context as Element);

    var provider = _getProvider<T>(context as Element, ref);
    if (provider != null) {
      return provider.value;
    }

    context.visitAncestorElements((element) {
      final p = _getProvider<T>(element, ref);
      if (p != null) {
        provider = p;
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
    final refProviders = _elementRefProviders.remove(context);
    if (refProviders == null) return;
    for (final provider in refProviders.values) {
      _disposeProvider(provider);
    }

    final dependencyRefs = _elementDependencyRefs.remove(context);
    for (final ref in dependencyRefs ?? const <ReadOnlyRef>[]) {
      _refDependentElements[ref]?.remove(context);
    }
  }

  @override
  void unmount() {
    for (final contextProviders in _elementRefProviders.values) {
      for (final provider in contextProviders.values) {
        _disposeProvider(provider);
      }
    }
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

void _noopDispose(_) {}
