import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt69<
  T0,
  TListenable1 extends ValueListenable<T2>,
  T2,
  TListenable3 extends ValueListenable<T4>,
  T4
>
    on
        (
          context_ref.ReadOnlyRef<Stream<T0>>,
          context_ref.ReadOnlyRef<TListenable1>,
          context_ref.ReadOnlyRef<TListenable3>,
        ) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, T2, T4) selector,
  ) {
    return watchOnly3<R, AsyncSnapshot<T0>, T2, T4, T0, T2, T4>(
      context,
      selector,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      AsyncSnapshot<T0>.nothing(),
      $2.of(context).value,
      $3.of(context).value,
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, T2, T4) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<AsyncSnapshot<T0>, T2, T4, T0, T2, T4>(
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
