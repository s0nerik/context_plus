import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt232<T0, TListenable1 extends ValueListenable<T2>, T2, T3, TListenable4 extends Listenable> on (Future<T0>, TListenable1, Future<T3>, TListenable4) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>, TListenable4) selector,
  ) {
    return watchOnly4<R, AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>, TListenable4, T0, T2, T3, TListenable4>(context, selector, $1, $2, $3, $4, AsyncSnapshot<T0>.nothing(), $2.value, AsyncSnapshot<T3>.nothing(), $4);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>, TListenable4) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>, TListenable4, T0, T2, T3, TListenable4>(context, effect, $1, $2, $3, $4, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
