import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt85<TListenable0 extends Listenable, TListenable1 extends Listenable, TListenable2 extends ValueListenable<T3>, T3, TListenable4 extends ValueListenable<T5>, T5> on (TListenable0, TListenable1, TListenable2, TListenable4) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable0, TListenable1, T3, T5) selector,
  ) {
    return watchOnly4<R, TListenable0, TListenable1, T3, T5, TListenable0, TListenable1, T3, T5>(context, selector, $1, $2, $3, $4, $1, $2, $3.value, $4.value);
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable0, TListenable1, T3, T5) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    return watchEffect4<TListenable0, TListenable1, T3, T5, TListenable0, TListenable1, T3, T5>(context, effect, $1, $2, $3, $4, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    return unwatchEffect4(context, $1, $2, $3, $4, key: key);
  }
}
