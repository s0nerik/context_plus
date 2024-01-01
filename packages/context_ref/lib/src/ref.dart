import 'package:flutter/widgets.dart';

import 'context_ref_root.dart';

abstract interface class ReadOnlyRef<T> {}

class Ref<T> implements ReadOnlyRef<T> {
  Ref(); // Must not be const

  T bind(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
  }) {
    final provider = ContextRefRoot.of(context).bind(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
    );
    return provider.value;
  }

  void bindLazy(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
  }) {
    ContextRefRoot.of(context).bind(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
    );
  }

  T bindValue(
    BuildContext context,
    T value,
  ) {
    final provider = ContextRefRoot.of(context).bindValue(
      context: context,
      ref: this,
      value: value,
    );
    return provider.value;
  }

  ReadOnlyRef<T> get readOnly => this;
}

extension ContextRefExt<T> on ReadOnlyRef<T> {
  T of(BuildContext context) => ContextRefRoot.of(context).get(context, this);
}
