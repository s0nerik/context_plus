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

  Provider<T> _getOrCreateProvider<T>(BuildContext context, Ref<T> ref) {
    final contextData = _contextData[context] ??= _ContextData();
    return (contextData.providers[ref] ??= Provider<T>()) as Provider<T>;
  }

  void bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() create,
    required void Function(T value)? dispose,
    required bool lazy,
  }) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);

    final provider = _getOrCreateProvider(context, ref);
    provider.creator = create;
    provider.disposer = dispose;
    if (!lazy) {
      provider.value;
    }
  }

  void bindValue<T>({
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
    provider.value = value;
  }

  T get<T>(BuildContext context, ReadOnlyRef<T> ref) {
    var provider = _contextData[context]?.providers[ref] as Provider<T>?;
    if (provider != null) {
      return provider.value;
    }

    context.visitAncestorElements((element) {
      final p = _contextData[element]?.providers[ref];
      if (p != null) {
        provider = p as Provider<T>;
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
    _disposeProvidersForContext(dependent);
    super.removeDependent(dependent);
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

void _disposeProvider<T>(Provider<T> provider) {
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
  final providers = HashMap<ReadOnlyRef, Provider>.identity();
}

void _noopDispose(_) {}
