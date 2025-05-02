import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt26<
  TListenable0 extends Listenable,
  T1,
  T2
>
    on
        (
          context_ref.ReadOnlyRef<TListenable0>,
          context_ref.ReadOnlyRef<Future<T1>>,
          context_ref.ReadOnlyRef<Future<T2>>,
        ) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>) selector,
  ) {
    return watchOnly3<
      R,
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      TListenable0,
      T1,
      T2
    >(
      context,
      selector,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      $1.of(context),
      AsyncSnapshot<T1>.nothing(),
      AsyncSnapshot<T2>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<
      TListenable0,
      AsyncSnapshot<T1>,
      AsyncSnapshot<T2>,
      TListenable0,
      T1,
      T2
    >(
      context,
      effect,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      key: key,
      immediate: immediate,
      once: once,
    );
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(
      context,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      key: key,
    );
  }
}
