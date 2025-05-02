import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt171<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  T4,
  T5
>
    on (TListenable0, TListenable2, Future<T4>, Stream<T5>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, T3, AsyncSnapshot<T4>, AsyncSnapshot<T5>) selector,
  ) {
    return watchOnly4<
      R,
      T1,
      T3,
      AsyncSnapshot<T4>,
      AsyncSnapshot<T5>,
      T1,
      T3,
      T4,
      T5
    >(
      context,
      selector,
      $1,
      $2,
      $3,
      $4,
      $1.value,
      $2.value,
      AsyncSnapshot<T4>.nothing(),
      AsyncSnapshot<T5>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, T3, AsyncSnapshot<T4>, AsyncSnapshot<T5>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<
      T1,
      T3,
      AsyncSnapshot<T4>,
      AsyncSnapshot<T5>,
      T1,
      T3,
      T4,
      T5
    >(
      context,
      effect,
      $1,
      $2,
      $3,
      $4,
      key: key,
      immediate: immediate,
      once: once,
    );
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
