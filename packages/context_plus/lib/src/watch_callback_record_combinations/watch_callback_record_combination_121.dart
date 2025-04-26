import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt121<TListenable0 extends Listenable, T1, T2, TListenable3 extends ValueListenable<T4>, T4> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<Future<T1>>, context_ref.ReadOnlyRef<Future<T2>>, context_ref.ReadOnlyRef<TListenable3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, T4) selector,
  ) {
    return watchOnly4<R, TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, T4, TListenable0, T1, T2, T4>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), $1.of(context), AsyncSnapshot<T1>.nothing(), AsyncSnapshot<T2>.nothing(), $4.of(context).value);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, T4) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, T4, TListenable0, T1, T2, T4>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
