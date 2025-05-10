import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt135<TListenable0 extends Listenable, T1, TListenable2 extends ValueListenable<T3>, T3, T4> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<Stream<T1>>, context_ref.ReadOnlyRef<TListenable2>, context_ref.ReadOnlyRef<Stream<T4>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>) selector,
  ) {
    return watchOnly4<R, TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>, TListenable0, T1, T3, T4>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>, TListenable0, T1, T3, T4>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.listenable, ContextWatcherObservableType.stream, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
