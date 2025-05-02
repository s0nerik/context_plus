import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt43<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2,
  T3
>
    on (TListenable0, Future<T2>, Stream<T3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>) selector,
  ) {
    return watchOnly3<R, T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T1, T2, T3>(
      context,
      selector,
      $1,
      $2,
      $3,
      $1.value,
      AsyncSnapshot<T2>.nothing(),
      AsyncSnapshot<T3>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T1, T2, T3>(
      context,
      effect,
      $1,
      $2,
      $3,
      key: key,
      immediate: immediate,
      once: once,
    );
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1, $2, $3, key: key);
  }
}
