// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

final class _GetxSubscription implements ContextWatchSubscription {
  _GetxSubscription({
    required this.observable,
    required StreamSubscription streamSubscription,
  }) : _sub = streamSubscription;

  final Rx observable;
  final StreamSubscription _sub;

  @override
  get callbackArgument => observable.value;

  @override
  void cancel() => _sub.cancel();
}

class GetxContextWatcher extends ContextWatcher<Rx> {
  GetxContextWatcher._();

  static final instance = GetxContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, Rx observable) {
    return _GetxSubscription(
      observable: observable,
      streamSubscription:
          observable.stream.listen((_) => rebuildIfNeeded(context, observable)),
    );
  }
}

extension GetxContextWatchExtension<T> on Rx<T> {
  /// Watch this [Rx] for changes.
  ///
  /// Whenever this [Rx] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watch();
    return value;
  }
}

extension GetxContextWatchOnlyExtension<T> on Rx<T> {
  /// Watch this [Rx] for changes.
  ///
  /// Whenever this [Rx] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(value);

    final selectedValue = selector(value);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }
}

extension ListenableContextWatchEffectExtension<T> on Rx<T> {
  /// Watch this [Rx] for changes.
  ///
  /// Whenever this [Rx] notifies of a change, the [effect] will be
  /// called, *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   observable.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   observable.unwatchEffect(context, key: 'effect');
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

extension ListenableContextUnwatchEffectExtension on Rx {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Rx] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
