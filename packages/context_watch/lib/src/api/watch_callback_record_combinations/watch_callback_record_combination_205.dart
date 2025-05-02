import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt205<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (TListenable0, Stream<T2>, Stream<T3>, TListenable4) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T5) selector,
  ) {
    return watchOnly4<
      R,
      T1,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
      T5,
      T1,
      T2,
      T3,
      T5
    >(
      context,
      selector,
      $1,
      $2,
      $3,
      $4,
      $1.value,
      AsyncSnapshot<T2>.nothing(),
      AsyncSnapshot<T3>.nothing(),
      $4.value,
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T5) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<
      T1,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
      T5,
      T1,
      T2,
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
