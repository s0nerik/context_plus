import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt26<TListenable0 extends Listenable, T1, T2> on (TListenable0, Future<T1>, Future<T2>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>) selector,
  ) {
    return watchOnly3<R, TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, TListenable0, T1, T2>(context, selector, $1, $2, $3, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future, ContextWatcherObservableType.future);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, TListenable0, T1, T2>(context, effect, $1, $2, $3, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future, ContextWatcherObservableType.future, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1, $2, $3, key: key);
  }
}
