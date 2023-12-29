import 'package:flutter/widgets.dart';

import 'context_ref_root.dart';
import 'ref_value.dart';

export 'ref_value.dart' show RefValueInitializer, RefValueDisposer;

abstract interface class ReadOnlyRef<T> {
  T of(BuildContext context);
}

class Ref<T> implements ReadOnlyRef<T> {
  Ref(); // Must not be const

  T bind(
    BuildContext context,
    RefValueInitializer<T> create, {
    RefValueDisposer<T>? dispose,
  }) {
    final root = ContextRefRoot.of(context);
    context.dependOnInheritedElement(root);
    return root.registerProvider(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
    );
  }

  void bindLazy(
    BuildContext context,
    RefValueInitializer<T> create, {
    RefValueDisposer<T>? dispose,
  }) {
    final root = ContextRefRoot.of(context);
    context.dependOnInheritedElement(root);
    root.registerLazyProvider(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
    );
  }

  T bindValue(BuildContext context, T value) {
    final root = ContextRefRoot.of(context);
    context.dependOnInheritedElement(root);
    return root.registerValueProvider(
      context: context,
      ref: this,
      value: value,
    );
  }

  @override
  T of(BuildContext context) => ContextRefRoot.of(context).get(context, this);

  ReadOnlyRef<T> get readOnly => this;
}
