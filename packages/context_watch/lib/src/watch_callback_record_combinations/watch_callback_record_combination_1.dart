// ignore_for_file: use_of_void_result

import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt1<TListenable1 extends Listenable, TListenable2 extends Listenable> on (TListenable1, TListenable2) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable1, TListenable2) selector,
  ) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final observable1 = contextWatch.getOrCreateObservable(context, $1);
    if (observable1 == null) return selector($1, $2);
    final arg1 = observable1.subscription.callbackArgument as TListenable1;

    final observable2 = contextWatch.getOrCreateObservable(context, $2)!;
    final arg2 = observable2.subscription.callbackArgument as TListenable2;
    
    final selectedValue = selector(arg1, arg2);
    observable1.watchOnly(
      (arg1) => selector(
        arg1,
        observable2.subscription.callbackArgument as TListenable2,
      ),
      selectedValue,
    );
    observable2.watchOnly(
      (arg2) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        arg2,
      ),
      selectedValue,
    );
    
    return selectedValue;
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable1, TListenable2) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final obs1 = contextWatch.getOrCreateObservable(context, $1);
    if (obs1 == null) return;
    final obs2 = contextWatch.getOrCreateObservable(context, $2)!;
    
    obs1.watchEffect((arg1) {
      if (shouldAbortMassEffect2(key, obs1, obs2,
          once: once, immediate: immediate)) {
        return;
      }
      final arg2 = obs2.subscription.callbackArgument as TListenable2;
      effect(arg1, arg2);
    }, key: key, immediate: immediate, once: once);
    obs2.watchEffect((arg2) {
      if (shouldAbortMassEffect2(key, obs1, obs2,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      effect(arg1, arg2);
    }, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    final contextWatch = InheritedContextWatch.of(context);
    
    contextWatch.unwatchEffect(context, $1, key);
    contextWatch.unwatchEffect(context, $2, key);
  }
}
