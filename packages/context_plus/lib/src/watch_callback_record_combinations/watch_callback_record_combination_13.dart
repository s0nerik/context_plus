import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt13<T0, TListenable1 extends ValueListenable<T2>, T2> on (context_ref.ReadOnlyRef<Stream<T0>>, context_ref.ReadOnlyRef<TListenable1>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, T2) selector,
  ) {
    return watchOnly2<R, AsyncSnapshot<T0>, T2, T0, T2>(context, selector, $1.of(context), $2.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.valueListenable);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, T2) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect2<AsyncSnapshot<T0>, T2, T0, T2>(context, effect, $1.of(context), $2.of(context), ContextWatcherObservableType.stream, ContextWatcherObservableType.valueListenable, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect2(context, $1.of(context), $2.of(context), key: key);
  }
}
