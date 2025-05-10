import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt72<T0, T1, TListenable2 extends Listenable> on (context_ref.ReadOnlyRef<Stream<T0>>, context_ref.ReadOnlyRef<Future<T1>>, context_ref.ReadOnlyRef<TListenable2>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2) selector,
  ) {
    return watchOnly3<R, AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, T0, T1, TListenable2>(context, selector, $1.of(context), $2.of(context), $3.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.future, ContextWatcherObservableType.listenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect3<AsyncSnapshot<T0>, AsyncSnapshot<T1>, TListenable2, T0, T1, TListenable2>(context, effect, $1.of(context), $2.of(context), $3.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.future, ContextWatcherObservableType.listenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect3(context, $1.of(context), $2.of(context), $3.of(context), key: key);
  }
}
