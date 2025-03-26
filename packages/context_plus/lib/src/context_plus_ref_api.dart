import 'package:context_plus_build_context/context_plus_build_context.dart';
import 'package:context_ref_core/context_ref_core.dart';
import 'package:flutter/widgets.dart';

extension ContextPlusRefAPI<T> on Ref<T> {
  /// A weak-reference map connecting Elements to their ContextPlusElementProxy instances.
  /// When an Element is garbage collected, its corresponding proxy will also be eligible
  /// for garbage collection.
  static final _elementProxies =
      WeakMap<BuildContext, ContextPlusElementProxy>();

  ///
  /// [create] is called only once per [BuildContext] and the value remains
  /// alive until the [BuildContext] is removed from the tree.
  ///
  /// [dispose] is called when the [BuildContext] is removed from the tree.
  /// If [dispose] is not specified, the provided value will be disposed by
  /// via `value.dispose()` if such method exists. Use [bindValue] if you don't
  /// want the value to be disposed automatically.
  ///
  /// [key] is used to identify the value. If [key] changes, the old value
  /// will be disposed and a new value will be created.
  T bind(
    BuildContext context,
    T Function(BuildContext context) create, {
    void Function(T value)? dispose,
    Object? key,
  }) {
    late ContextPlusElementProxy elementProxy;
    late ValueProvider<T> provider;
    void onMarkNeedsBuild() {
      final creator = provider.creator;
      if (creator == null) return;

      final updatedValue = creator();
      if (updatedValue == provider.value) return;

      provider.dispose();
      provider.value = updatedValue;
      scheduleElementRebuild(context as Element);
      for (final element in dependents) {
        scheduleElementRebuild(element);
      }
    }

    elementProxy = _elementProxies[context] ??=
        ContextPlusElementProxy(context as Element, onMarkNeedsBuild);
    provider = ContextRefRoot.of(context).bind(
      context: elementProxy,
      ref: this,
      create: () => create(elementProxy),
      dispose: dispose,
      key: key,
    );
    return provider.value;
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the value
  /// is requested for the first.
  void bindLazy(
    BuildContext context,
    T Function(BuildContext context) create, {
    void Function(T value)? dispose,
    Object? key,
  }) {
    final provider = ContextRefRoot.of(context).bind(
      context: context,
      ref: this,
      create: () => create(_elementProxies[context]!),
      dispose: dispose,
      key: key,
    );
    _elementProxies[context] ??=
        ContextPlusElementProxy(context as Element, provider.dispose);
  }

  /// Bind a value to this [Ref] for this and all descendant [BuildContext]s.
  ///
  /// [value] is used as the value of this [Ref]. If [value] changes, all
  /// widgets that depend on this [Ref] will be rebuilt.
  ///
  /// This method doesn't manage the lifecycle of the value. It is up to the
  /// caller to dispose the value when it is no longer needed.
  ///
  /// Use [bind] if you want the value to be disposed automatically.
  T bindValue(
    BuildContext context,
    T value,
  ) =>
      RefAPI(this).bindValue(context, value);
}
