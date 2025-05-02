import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt246<
  T0,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  T4
>
    on
        (
          context_ref.ReadOnlyRef<Future<T0>>,
          context_ref.ReadOnlyRef<Future<T1>>,
          context_ref.ReadOnlyRef<TListenable2>,
          context_ref.ReadOnlyRef<Future<T4>>,
        ) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>)
    selector,
  ) {
    return watchOnly4<
      R,
      AsyncSnapshot<T0>,
      AsyncSnapshot<T1>,
      T3,
      AsyncSnapshot<T4>,
      T0,
      T1,
      T3,
      T4
    >(
      context,
      selector,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      $4.of(context),
      AsyncSnapshot<T0>.nothing(),
      AsyncSnapshot<T1>.nothing(),
      $3.of(context).value,
      AsyncSnapshot<T4>.nothing(),
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>)
    effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<
      AsyncSnapshot<T0>,
      AsyncSnapshot<T1>,
      T3,
      AsyncSnapshot<T4>,
      T0,
      T1,
      T3,
      T4
    >(
      context,
      effect,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      $4.of(context),
      key: key,
      immediate: immediate,
      once: once,
    );
  }

  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(
      context,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      $4.of(context),
      key: key,
    );
  }
}
