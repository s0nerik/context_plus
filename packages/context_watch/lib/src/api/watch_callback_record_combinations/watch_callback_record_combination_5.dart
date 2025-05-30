import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt5<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends ValueListenable<T3>, T3> on (TListenable0, TListenable2) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, T3) selector,
  ) {
    return watchOnly2<R, T1, T3, T1, T3>(context, selector, $1, $2, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, T3) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect2<T1, T3, T1, T3>(context, effect, $1, $2, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect2(context, $1, $2, key: key);
  }
}
