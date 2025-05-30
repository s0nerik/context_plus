import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt100<TListenable0 extends Listenable, TListenable1 extends ValueListenable<T2>, T2, TListenable3 extends ValueListenable<T4>, T4, TListenable5 extends Listenable> on (TListenable0, TListenable1, TListenable3, TListenable5) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, T2, T4, TListenable5) selector,
  ) {
    return watchOnly4<R, TListenable0, T2, T4, TListenable5, TListenable0, T2, T4, TListenable5>(context, selector, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.listenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, T2, T4, TListenable5) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, T2, T4, TListenable5, TListenable0, T2, T4, TListenable5>(context, effect, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.listenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
