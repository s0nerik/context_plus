import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt83<TListenable0 extends Listenable, TListenable1 extends Listenable, TListenable2 extends Listenable, T3> on (TListenable0, TListenable1, TListenable2, Stream<T3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, TListenable1, TListenable2, AsyncSnapshot<T3>) selector,
  ) {
    return watchOnly4<R, TListenable0, TListenable1, TListenable2, AsyncSnapshot<T3>, TListenable0, TListenable1, TListenable2, T3>(context, selector, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, TListenable1, TListenable2, AsyncSnapshot<T3>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, TListenable1, TListenable2, AsyncSnapshot<T3>, TListenable0, TListenable1, TListenable2, T3>(context, effect, $1, $2, $3, $4, ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
