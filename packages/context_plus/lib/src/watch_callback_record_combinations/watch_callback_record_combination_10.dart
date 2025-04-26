import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt10<T0, T1> on (context_ref.ReadOnlyRef<Future<T0>>, context_ref.ReadOnlyRef<Future<T1>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>) selector,
  ) {
    return watchOnly2<R, AsyncSnapshot<T0>, AsyncSnapshot<T1>, T0, T1>(context, selector, $1.of(context), $2.of(context), AsyncSnapshot<T0>.nothing(), AsyncSnapshot<T1>.nothing());
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect2<AsyncSnapshot<T0>, AsyncSnapshot<T1>, T0, T1>(context, effect, $1.of(context), $2.of(context), key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect2(context, $1.of(context), $2.of(context), key: key);
  }
}
