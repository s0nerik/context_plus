import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt39<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends ValueListenable<T3>, T3, T4> on (TListenable0, TListenable2, Stream<T4>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, T3, AsyncSnapshot<T4>) selector,
  ) {
    return watchOnly3<R, T1, T3, AsyncSnapshot<T4>, T1, T3, T4>(context, selector, $1, $2, $3, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, T3, AsyncSnapshot<T4>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<T1, T3, AsyncSnapshot<T4>, T1, T3, T4>(context, effect, $1, $2, $3, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1, $2, $3, key: key);
  }
}
