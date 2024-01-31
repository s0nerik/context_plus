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

  final _refs = HashMap<Element, HashSet<ReadOnlyRef>>.identity();

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

    final provider = ref.getOrCreateProvider(context as Element);
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

    final provider = ref.getOrCreateProvider(context as Element);
    provider.creator = null;
    provider.disposer = _noopDispose;
    if (provider.shouldUpdateValue(value)) {
      provider.value = value;
      for (final element in ref.dependents) {
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

    ref.dependents.add(context as Element);

    var provider =
        ref.dependentProvidersCache[context] ?? ref.providers[context];
    if (provider == null) {
      context.visitAncestorElements((element) {
        final p = ref.providers[element];
        if (p != null) {
          provider = p;
          ref.dependentProvidersCache[context] = p;
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
    _disposeContextData(dependent);
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
    for (final element in _refs.keys) {
      _disposeContextData(element);
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
