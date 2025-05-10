import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt181<TListenable0 extends ValueListenable<T1>, T1, T2, TListenable3 extends ValueListenable<T4>, T4, TListenable5 extends ValueListenable<T6>, T6> on (TListenable0, Future<T2>, TListenable3, TListenable5) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, AsyncSnapshot<T2>, T4, T6) selector,
  ) {
    return watchOnly4<R, T1, AsyncSnapshot<T2>, T4, T6, T1, T2, T4, T6>(context, selector, $1, $2, $3, $4, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.future, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, AsyncSnapshot<T2>, T4, T6) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<T1, AsyncSnapshot<T2>, T4, T6, T1, T2, T4, T6>(context, effect, $1, $2, $3, $4, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.future, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
