// ignore_for_file: use_of_void_result

import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordExt48<TListenable1 extends Listenable, T2, TListenable3 extends Listenable, T4> on (TListenable1, Future<T2>, TListenable3, Stream<T4>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable1, AsyncSnapshot<T2>, TListenable3, AsyncSnapshot<T4>) selector,
  ) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final observable1 = contextWatch.getOrCreateObservable(context, $1);
    if (observable1 == null) return selector($1, AsyncSnapshot<T2>.nothing(), $3, AsyncSnapshot<T4>.nothing());
    final arg1 = observable1.subscription.callbackArgument as TListenable1;

    final observable2 = contextWatch.getOrCreateObservable<T2>(context, $2)!;
    final arg2 = observable2.subscription.callbackArgument as AsyncSnapshot<T2>;

    final observable3 = contextWatch.getOrCreateObservable(context, $3)!;
    final arg3 = observable3.subscription.callbackArgument as TListenable3;

    final observable4 = contextWatch.getOrCreateObservable<T4>(context, $4)!;
    final arg4 = observable4.subscription.callbackArgument as AsyncSnapshot<T4>;
    
    final selectedValue = selector(arg1, arg2, arg3, arg4);
    observable1.watchOnly(
      (arg1) => selector(
        arg1,
        observable2.subscription.callbackArgument as AsyncSnapshot<T2>,
        observable3.subscription.callbackArgument as TListenable3,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable2.watchOnly(
      (arg2) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        arg2,
        observable3.subscription.callbackArgument as TListenable3,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable3.watchOnly(
      (arg3) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        observable2.subscription.callbackArgument as AsyncSnapshot<T2>,
        arg3,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable4.watchOnly(
      (arg4) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        observable2.subscription.callbackArgument as AsyncSnapshot<T2>,
        observable3.subscription.callbackArgument as TListenable3,
        arg4,
      ),
      selectedValue,
    );
    
    return selectedValue;
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable1, AsyncSnapshot<T2>, TListenable3, AsyncSnapshot<T4>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final obs1 = contextWatch.getOrCreateObservable(context, $1);
    if (obs1 == null) return;
    final obs2 = contextWatch.getOrCreateObservable<T2>(context, $2)!;
    final obs3 = contextWatch.getOrCreateObservable(context, $3)!;
    final obs4 = contextWatch.getOrCreateObservable<T4>(context, $4)!;
    
    obs1.watchEffect((arg1) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg2 = obs2.subscription.callbackArgument as AsyncSnapshot<T2>;
      final arg3 = obs3.subscription.callbackArgument as TListenable3;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs2.watchEffect((arg2) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg3 = obs3.subscription.callbackArgument as TListenable3;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs3.watchEffect((arg3) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg2 = obs2.subscription.callbackArgument as AsyncSnapshot<T2>;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs4.watchEffect((arg4) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg2 = obs2.subscription.callbackArgument as AsyncSnapshot<T2>;
      final arg3 = obs3.subscription.callbackArgument as TListenable3;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    final contextWatch = InheritedContextWatch.of(context);
    
    contextWatch.unwatchEffect(context, $1, key);
    contextWatch.unwatchEffect(context, $2, key);
    contextWatch.unwatchEffect(context, $3, key);
    contextWatch.unwatchEffect(context, $4, key);
  }
}
