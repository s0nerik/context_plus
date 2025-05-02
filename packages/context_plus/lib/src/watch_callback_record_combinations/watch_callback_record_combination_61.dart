import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt61<
  T0,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3
>
    on
        (
          context_ref.ReadOnlyRef<Future<T0>>,
          context_ref.ReadOnlyRef<Stream<T1>>,
          context_ref.ReadOnlyRef<TListenable2>,
        ) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3) selector,
  ) {
    return watchOnly3<R, AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, T0, T1, T3>(
      context,
      selector,
      $1.of(context),
      $2.of(context),
      $3.of(context),
      AsyncSnapshot<T0>.nothing(),
      AsyncSnapshot<T1>.nothing(),
      $3.of(context).value,
    );
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, T0, T1, T3>(
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
