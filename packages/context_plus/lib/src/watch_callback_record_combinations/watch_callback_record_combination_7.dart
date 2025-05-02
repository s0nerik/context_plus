import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt7<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2
>
    on
        (
          context_ref.ReadOnlyRef<TListenable0>,
          context_ref.ReadOnlyRef<Stream<T2>>,
        ) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, AsyncSnapshot<T2>) selector,
  ) {
    return watchOnly2<R, T1, AsyncSnapshot<T2>, T1, T2>(
      context,
      selector,
      $1.of(context),
      $2.of(context),
      $1.of(context).value,
      AsyncSnapshot<T2>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, AsyncSnapshot<T2>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect2<T1, AsyncSnapshot<T2>, T1, T2>(
      context,
      effect,
      $1.of(context),
      $2.of(context),
      key: key,
      immediate: immediate,
      once: once,
    );
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect2(context, $1.of(context), $2.of(context), key: key);
  }
}
