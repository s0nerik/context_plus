import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt50<T0, TListenable1 extends Listenable, T2> on (context_ref.ReadOnlyRef<Future<T0>>, context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<Future<T2>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>) selector,
  ) {
    return watchOnly3<R, AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>, T0, TListenable1, T2>(context, selector, $1.of(context), $2.of(context), $3.of(context), ContextWatcherObservableType.future, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>, T0, TListenable1, T2>(context, effect, $1.of(context), $2.of(context), $3.of(context), ContextWatcherObservableType.future, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1.of(context), $2.of(context), $3.of(context), key: key);
  }
}
