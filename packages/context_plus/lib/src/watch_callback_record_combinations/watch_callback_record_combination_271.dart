import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt271<T0, T1, T2, T3> on (context_ref.ReadOnlyRef<Future<T0>>, context_ref.ReadOnlyRef<Stream<T1>>, context_ref.ReadOnlyRef<Stream<T2>>, context_ref.ReadOnlyRef<Stream<T3>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>) selector,
  ) {
    return watchOnly4<R, AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T0, T1, T2, T3>(context, selector, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.future, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T0, T1, T2, T3>(context, effect, $1.of(context), $2.of(context), $3.of(context), $4.of(context), ContextWatcherObservableType.future, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream, ContextWatcherObservableType.stream, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1.of(context), $2.of(context), $3.of(context), $4.of(context), key: key);
  }
}
