import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt49<T0, TListenable1 extends Listenable, TListenable2 extends ValueListenable<T3>, T3> on (Future<T0>, TListenable1, TListenable2) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, TListenable1, T3) selector,
  ) {
    return watchOnly3<R, AsyncSnapshot<T0>, TListenable1, T3, T0, TListenable1, T3>(context, selector, $1, $2, $3, ContextWatcherObservableType.future, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, TListenable1, T3) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<AsyncSnapshot<T0>, TListenable1, T3, T0, TListenable1, T3>(context, effect, $1, $2, $3, ContextWatcherObservableType.future, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1, $2, $3, key: key);
  }
}
