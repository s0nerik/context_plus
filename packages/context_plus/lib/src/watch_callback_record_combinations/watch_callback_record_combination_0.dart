import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt0<TListenable0 extends Listenable, TListenable1 extends Listenable> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<TListenable1>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, TListenable1) selector,
  ) {
    return watchOnly2<R, TListenable0, TListenable1, TListenable0, TListenable1>(context, selector, $1.of(context), $2.of(context), ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, TListenable1) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect2<TListenable0, TListenable1, TListenable0, TListenable1>(context, effect, $1.of(context), $2.of(context), ContextWatcherObservableType.listenable, ContextWatcherObservableType.listenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect2(context, $1.of(context), $2.of(context), key: key);
  }
}
