import 'package:flutter/widgets.dart';

import 'src/context_use_root.dart';

class ContextUse {
  static Widget root({
    Key? key,
    required Widget child,
  }) =>
      ContextUseRoot(child: child);
}

extension ContextUseExt on BuildContext {
  T use<T>(
    T Function() create, {
    void Function(T instance)? dispose,
    Object? key,
  }) {
    final root = ContextUseRoot.of(this);
    dependOnInheritedElement(root);
    final provider = root.use<T>(
      context: this,
      create: create,
      dispose: dispose,
      lazy: false,
      key: key,
    );
    return provider.value;
  }

  T Function() useLazy<T>(
    T Function() create, {
    void Function(T instance)? dispose,
    Object? key,
  }) {
    final root = ContextUseRoot.of(this);
    dependOnInheritedElement(root);
    final provider = root.use<T>(
      context: this,
      create: create,
      dispose: dispose,
      lazy: true,
      key: key,
    );
    return () => provider.value;
  }
}
