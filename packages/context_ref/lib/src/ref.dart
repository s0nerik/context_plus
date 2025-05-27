import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'context_ref_root.dart';
import 'context_ticker_provider.dart';
import 'value_provider.dart';

/// A read-only reference to a value that can be bound to a [BuildContext].
abstract class ReadOnlyRef<T> {
  ReadOnlyRef._();

  final _providers = HashMap<Element, ValueProvider<T>>.identity();

  final _dependents = HashSet<Element>.identity();
  var _dependentProvidersCache = HashMap<Element, ValueProvider<T>?>.identity();
}

@internal
extension InternalReadOnlyRefAPI<T> on ReadOnlyRef<T> {
  HashMap<Element, ValueProvider<T>> get providers => _providers;
  HashSet<Element> get dependents => _dependents;
  HashMap<Element, ValueProvider<T>?> get dependentProvidersCache =>
      _dependentProvidersCache;

  ValueProvider<T> getOrCreateProvider(Element element) {
    final existingProvider = _providers[element];
    if (existingProvider != null) {
      return existingProvider;
    }

    final provider = ValueProvider<T>();
    _providers[element] = provider;
    _dependentProvidersCache = HashMap.identity();
    return provider;
  }
}

/// A reference to a value that can be bound to a [BuildContext].
class Ref<T> extends ReadOnlyRef<T> {
  Ref() : super._(); // Must not be const

  /// Returns a read-only version of this [Ref]. The returned [ReadOnlyRef]
  /// can be used to get the value of this [Ref] without being able to change
  /// the provided value.
  ReadOnlyRef<T> get readOnly => this;
}

extension ReadOnlyRefAPI<T> on ReadOnlyRef<T> {
  /// Get the value of this [Ref] from the given [context].
  T of(BuildContext context) {
    final provider = ContextRefRoot.of(context).get<T>(context, this);
    assert(
      provider != null,
      'Ref<$T> is not bound. You probably forgot to bind it in a parent context.',
    );
    return provider!.value;
  }

  T? maybeOf(BuildContext context) {
    final provider = ContextRefRoot.of(context).get<T>(context, this);
    return provider?.value;
  }
}

extension RefAPI<T> on Ref<T> {
  /// Bind a value to this [Ref] for this and all descendant [BuildContext]s.
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
  ///
  /// [allowRebind] allows calling [bind] for the same [context] and [key]
  /// multiple times per frame. This is prohibited by default to avoid
  /// accidentally re-binding the value to a different value, but can be
  /// useful for writing utility functions that depend on a [Ref] and
  /// can be called multiple times per build.
  T bind(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
    Object? key,
    bool allowRebind = false,
  }) {
    final provider = ContextRefRoot.of(context).bind(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
      key: key,
      allowRebind: allowRebind,
    );
    final value = provider.value;

    // allow `context.vsync` to properly react to `TickerMode` changes
    contextTickerProviders[context]
        ?.tickerModeNotifier = TickerMode.getNotifier(context);

    return value;
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the value
  /// is requested for the first.
  void bindLazy(
    BuildContext context,
    T Function() create, {
    void Function(T value)? dispose,
    Object? key,
    bool allowRebind = false,
  }) {
    ContextRefRoot.of(context).bind(
      context: context,
      ref: this,
      create: create,
      dispose: dispose,
      key: key,
      allowRebind: allowRebind,
    );

    // allow `context.vsync` to properly react to `TickerMode` changes
    contextTickerProviders[context]
        ?.tickerModeNotifier = TickerMode.getNotifier(context);
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
  T bindValue(BuildContext context, T value) {
    final provider = ContextRefRoot.of(
      context,
    ).bindValue(context: context, ref: this, value: value);
    return provider.value;
  }
}
