import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt118<TListenable0 extends Listenable, T1, TListenable2 extends ValueListenable<T3>, T3, T4> on (TListenable0, Future<T1>, TListenable2, Future<T4>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>) selector,
  ) {
    return watchOnly4<R, TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>, TListenable0, T1, T3, T4>(context, selector, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.future);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>, TListenable0, T1, T3, T4>(context, effect, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.future, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.future, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
