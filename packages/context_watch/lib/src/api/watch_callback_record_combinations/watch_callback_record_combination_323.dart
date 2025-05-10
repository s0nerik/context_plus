import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt323<T0, T1, TListenable2 extends Listenable, T3> on (Stream<T0>, Stream<T1>, TListenable2, Stream<T3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, AsyncSnapshot<T3>) selector,
  ) {
    return watchOnly4<R, AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, AsyncSnapshot<T3>, T0, T1, TListenable2, T3>(context, selector, $1, $2, $3, $4, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream, ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, AsyncSnapshot<T3>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, AsyncSnapshot<T3>, T0, T1, TListenable2, T3>(context, effect, $1, $2, $3, $4, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream, ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
