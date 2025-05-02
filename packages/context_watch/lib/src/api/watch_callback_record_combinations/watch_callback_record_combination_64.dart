import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt64<
  T0,
  TListenable1 extends Listenable,
  TListenable2 extends Listenable
>
    on (Stream<T0>, TListenable1, TListenable2) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, TListenable1, TListenable2) selector,
  ) {
    return watchOnly3<
      R,
      AsyncSnapshot<T0>,
      TListenable1,
      TListenable2,
      T0,
      TListenable1,
      TListenable2
    >(context, selector, $1, $2, $3, AsyncSnapshot<T0>.nothing(), $2, $3);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, TListenable1, TListenable2) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<
      AsyncSnapshot<T0>,
      TListenable1,
      TListenable2,
      T0,
      TListenable1,
      TListenable2
    >(context, effect, $1, $2, $3, key: key, immediate: immediate, once: once);
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1, $2, $3, key: key);
  }
}
