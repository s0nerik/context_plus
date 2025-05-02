import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt126<
  TListenable0 extends Listenable,
  T1,
  T2,
  T3
>
    on (TListenable0, Future<T1>, Stream<T2>, Future<T3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
    )
    selector,
  ) {
    return watchOnly4<
      R,
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
      TListenable0,
      T1,
      T2,
      T3
    >(
      context,
      selector,
      $1,
      $2,
      $3,
      $4,
      $1,
      AsyncSnapshot<T1>.nothing(),
      AsyncSnapshot<T2>.nothing(),
      AsyncSnapshot<T3>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
    )
    effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      AsyncSnapshot<T3>,
      TListenable0,
      T1,
      T2,
      T3
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
