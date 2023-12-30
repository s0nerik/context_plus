import 'package:flutter/widgets.dart';

import 'src/context_use_root.dart';

extension ContextUseExt on BuildContext {
  T use<T>(
    T Function() create, {
    void Function(T instance)? dispose,
  }) {
    final root = ContextUseRoot.of(this);
    dependOnInheritedElement(root);
    final provider = root.use<T>(
      context: this,
      create: create,
      dispose: dispose,
      lazy: false,
    );
    return provider.value;
  }

  T Function() useLazy<T>(
    T Function() create, {
    void Function(T instance)? dispose,
  }) {
    final root = ContextUseRoot.of(this);
    dependOnInheritedElement(root);
    final provider = root.use<T>(
      context: this,
      create: create,
      dispose: dispose,
      lazy: true,
    );
    return () => provider.value;
  }
}
