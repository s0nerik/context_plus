import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt309<
  T0,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (Stream<T0>, Future<T1>, TListenable2, TListenable4) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, T5) selector,
  ) {
    return watchOnly4<
      R,
      AsyncSnapshot<T0>,
      AsyncSnapshot<T1>,
      T3,
      T5,
      T0,
      T1,
      T3,
      T5
    >(
      context,
      selector,
      $1,
      $2,
      $3,
      $4,
      AsyncSnapshot<T0>.nothing(),
      AsyncSnapshot<T1>.nothing(),
      $3.value,
      $4.value,
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, T5) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<
      AsyncSnapshot<T0>,
      AsyncSnapshot<T1>,
      T3,
      T5,
      T0,
      T1,
      T3,
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
