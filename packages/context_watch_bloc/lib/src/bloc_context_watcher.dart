// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

class _BlocSubscription implements ContextWatchSubscription {
  _BlocSubscription({
    required this.observable,
    required StreamSubscription streamSubscription,
  }) : _sub = streamSubscription;

  final StreamSubscription _sub;

  @override
  final StateStreamable observable;

  @override
  get hasValue => true;

  @override
  get value => observable.state;

  @override
  get selectorParameterType => ContextWatchSelectorParameterType.value;

  @override
  void cancel() => _sub.cancel();
}

class BlocContextWatcher extends ContextWatcher<StateStreamable> {
  BlocContextWatcher._();

  static final instance = BlocContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, StateStreamable observable) {
    return _BlocSubscription(
      observable: observable,
      streamSubscription: observable.stream.listen(
        (_) => rebuildIfNeeded(context, observable),
      ),
    );
  }
}

extension BlocContextWatchExtension<T> on StateStreamable<T> {
  /// Watch this [StateStreamable] for changes.
  ///
  /// Whenever this [StateStreamable] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watch();
    return state;
  }
}

extension BlocContextWatchOnlyExtension<T> on StateStreamable<T> {
  /// Watch this [StateStreamable] for changes.
  ///
  /// Whenever this [StateStreamable] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(state);

    final selectedValue = selector(state);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }
}

extension ListenableContextWatchEffectExtension<T> on StateStreamable<T> {
  /// Watch this [StateStreamable] for changes.
  ///
  /// Whenever this [StateStreamable] notifies of a change, the [effect] will be
  /// called, *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   bloc.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   bloc.unwatchEffect(context, key: 'effect');
  /// }
  /// ```
  ///
  /// If [immediate] is `true`, the effect will be called upon effect
  /// registration immediately. If [once] is `true`, the effect will be called
  /// only once. These parameters can be combined.
  ///
  /// [immediate] and [once] parameters require a unique [key].
  void watchEffect(
    BuildContext context,
    void Function(T value) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }
}

extension ListenableContextUnwatchEffectExtension on StateStreamable {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [StateStreamable] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
