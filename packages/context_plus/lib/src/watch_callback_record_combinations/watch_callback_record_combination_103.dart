import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt103<TListenable0 extends Listenable, TListenable1 extends ValueListenable<T2>, T2, TListenable3 extends ValueListenable<T4>, T4, T5> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<TListenable3>, context_ref.ReadOnlyRef<Stream<T5>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, T2, T4, AsyncSnapshot<T5>) selector,
  ) {
    return watchOnly4<R, TListenable0, T2, T4, AsyncSnapshot<T5>, TListenable0, T2, T4, T5>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), $1.of(context), $2.of(context).value, $3.of(context).value, AsyncSnapshot<T5>.nothing());
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, T2, T4, AsyncSnapshot<T5>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, T2, T4, AsyncSnapshot<T5>, TListenable0, T2, T4, T5>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
