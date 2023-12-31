import 'dart:collection';

import 'package:flutter/widgets.dart';

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

  void bind<T>({
    required BuildContext context,
    required Ref<T> ref,
    required T Function() provider,
  }) {
    // Make [context] dependent on this element so that we can get notified
    // when the [context] is removed from the tree.
    context.dependOnInheritedElement(this);
    final contextData = _contextData[context] ??= _ContextData();
    contextData.providers[ref] = provider;
  }

  T get<T>(BuildContext context, Ref<T> ref) {
    var provider = _contextData[context]?.providers[ref] as _Provider<T>?;
    if (provider != null) {
      return provider();
    }

    context.visitAncestorElements((element) {
      final p = _contextData[element]?.providers[ref];
      if (p != null) {
        provider = p as _Provider<T>;
        return false;
      }
      return true;
    });

    assert(
      provider != null,
      '$ref is not bound. You probably forgot to call Ref.bind() on a parent context.',
    );

    return provider!();
  }

  @override
  void removeDependent(Element dependent) {
    _contextData.remove(dependent);
    super.removeDependent(dependent);
  }
}

class _ContextData {
  final providers = HashMap<Ref, _Provider>.identity();
}

typedef _Provider<T> = T Function();
