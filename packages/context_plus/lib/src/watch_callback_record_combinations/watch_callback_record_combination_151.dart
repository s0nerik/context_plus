import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt151<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends Listenable, TListenable3 extends ValueListenable<T4>, T4, T5> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<TListenable2>, context_ref.ReadOnlyRef<TListenable3>, context_ref.ReadOnlyRef<Stream<T5>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(T1, TListenable2, T4, AsyncSnapshot<T5>) selector,
  ) {
    return watchOnly4<R, T1, TListenable2, T4, AsyncSnapshot<T5>, T1, TListenable2, T4, T5>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(T1, TListenable2, T4, AsyncSnapshot<T5>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<T1, TListenable2, T4, AsyncSnapshot<T5>, T1, TListenable2, T4, T5>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.listenable, ContextWatcherObservableType.valueListenable, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
