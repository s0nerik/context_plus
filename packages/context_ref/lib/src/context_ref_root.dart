import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'ref.dart';
import 'ref_value.dart';

class ContextRefRoot extends InheritedWidget {
  const ContextRefRoot({
    super.key,
    required super.child,
  });

  static InheritedContextGetElement of(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<ContextRefRoot>()
            as InheritedContextGetElement?;
    assert(
      element != null,
      'No ContextRef.root() found. Did you forget to add a ContextRef.root() widget?',
    );
    return element!;
  }

  @override
  InheritedContextGetElement createElement() =>
      InheritedContextGetElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class InheritedContextGetElement extends InheritedElement {
  InheritedContextGetElement(super.widget);

  final _contextData = HashMap<BuildContext, _ContextData>.identity();

  T registerProvider<T>({
    required BuildContext context,
    required Ref<T> ref,
    required RefValueInitializer<T> create,
    required RefValueDisposer<T>? dispose,
  }) {
    final contextData = _contextData[context] ??= _ContextData();

    final existingProvider = contextData.providers[ref];
    if (existingProvider != null) {
      return existingProvider.value as T;
    }

    final provider = RefValue<T>(create, dispose: dispose, lazy: false);
    contextData.providers[ref] = provider;
    return provider.value;
  }

  T registerValueProvider<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T value,
  }) {
    final contextData = _contextData[context] ??= _ContextData();

    final existingProvider = contextData.providers[ref];
    // TODO: handle value -> non-value provider transition
    if (existingProvider != null && existingProvider.value == value) {
      return value;
    }

    final provider =
        RefValue<T>(() => value, dispose: _noopDispose, lazy: false);
    contextData.providers[ref] = provider;
    return provider.value;
  }

  void registerLazyProvider<T>({
    required BuildContext context,
    required Ref<T> ref,
    required RefValueInitializer<T> create,
    required RefValueDisposer<T>? dispose,
  }) {
    final contextData = _contextData[context] ??= _ContextData();

    final existingProvider = contextData.providers[ref];
    if (existingProvider != null) {
      return;
    }

    final provider = RefValue<T>(create, dispose: dispose, lazy: true);
    contextData.providers[ref] = provider;
  }

  T get<T>(BuildContext context, Ref<T> providerRef) {
    RefValue<T>? provider =
        _contextData[context]?.providers[providerRef] as RefValue<T>?;
    if (provider != null) {
      return provider.value;
    }

    context.visitAncestorElements((element) {
      final p = _contextData[element]?.providers[providerRef];
      if (p != null) {
        provider = p as RefValue<T>;
        return false;
      }
      return true;
    });

    assert(
      provider != null,
      'No provider found for $providerRef',
    );

    return provider!.value;
  }

  @override
  void removeDependent(Element dependent) {
    _disposeProvidersForContext(dependent);
    super.removeDependent(dependent);
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

  void _disposeProvidersForContext(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final provider in contextData.providers.values) {
      _disposeProvider(provider);
    }
  }
}

void _disposeProvider<T>(RefValue<T> provider) {
  if (!kDebugMode) {
    provider.dispose();
    return;
  }

  try {
    provider.dispose();
  } catch (e) {
    if (e.runtimeType.toString() != '_CompileTimeError') {
      rethrow;
    }
  }
}

class _ContextData {
  final providers = HashMap<Ref, RefValue>.identity();
}

void _noopDispose(_) {}
