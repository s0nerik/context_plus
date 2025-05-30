import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt277<T0, TListenable1 extends Listenable, TListenable2 extends ValueListenable<T3>, T3, TListenable4 extends ValueListenable<T5>, T5> on (context_ref.ReadOnlyRef<Stream<T0>>, context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<TListenable2>, context_ref.ReadOnlyRef<TListenable4>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, TListenable1, T3, T5) selector,
  ) {
    return watchOnly4<R, AsyncSnapshot<T0>, TListenable1, T3, T5, T0, TListenable1, T3, T5>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, TListenable1, T3, T5) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<AsyncSnapshot<T0>, TListenable1, T3, T5, T0, TListenable1, T3, T5>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.valueListenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
