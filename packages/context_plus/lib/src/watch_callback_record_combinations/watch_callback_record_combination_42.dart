// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt42<TListenable1 extends Listenable, TListenable2 extends Listenable, T3, T4> on (context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<TListenable2>, context_ref.ReadOnlyRef<Future<T3>>, context_ref.ReadOnlyRef<Stream<T4>>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(TListenable1, TListenable2, AsyncSnapshot<T3>, AsyncSnapshot<T4>) selector,
  ) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final observable1 = contextWatch.getOrCreateObservable(context, $1);
    if (observable1 == null) return selector($1.of(context), $2.of(context), AsyncSnapshot<T3>.nothing(), AsyncSnapshot<T4>.nothing());
    final arg1 = observable1.subscription.callbackArgument as TListenable1;

    final observable2 = contextWatch.getOrCreateObservable(context, $2)!;
    final arg2 = observable2.subscription.callbackArgument as TListenable2;

    final observable3 = contextWatch.getOrCreateObservable<T3>(context, $3)!;
    final arg3 = observable3.subscription.callbackArgument as AsyncSnapshot<T3>;

    final observable4 = contextWatch.getOrCreateObservable<T4>(context, $4)!;
    final arg4 = observable4.subscription.callbackArgument as AsyncSnapshot<T4>;
    
    final selectedValue = selector(arg1, arg2, arg3, arg4);
    observable1.watchOnly(
      (arg1) => selector(
        arg1,
        observable2.subscription.callbackArgument as TListenable2,
        observable3.subscription.callbackArgument as AsyncSnapshot<T3>,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable2.watchOnly(
      (arg2) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        arg2,
        observable3.subscription.callbackArgument as AsyncSnapshot<T3>,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable3.watchOnly(
      (arg3) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        observable2.subscription.callbackArgument as TListenable2,
        arg3,
        observable4.subscription.callbackArgument as AsyncSnapshot<T4>,
      ),
      selectedValue,
    );
    observable4.watchOnly(
      (arg4) => selector(
        observable1.subscription.callbackArgument as TListenable1,
        observable2.subscription.callbackArgument as TListenable2,
        observable3.subscription.callbackArgument as AsyncSnapshot<T3>,
        arg4,
      ),
      selectedValue,
    );
    
    return selectedValue;
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(TListenable1, TListenable2, AsyncSnapshot<T3>, AsyncSnapshot<T4>) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final obs1 = contextWatch.getOrCreateObservable(context, $1.of(context));
    if (obs1 == null) return;
    final obs2 = contextWatch.getOrCreateObservable(context, $2.of(context))!;
    final obs3 = contextWatch.getOrCreateObservable<T3>(context, $3.of(context))!;
    final obs4 = contextWatch.getOrCreateObservable<T4>(context, $4.of(context))!;
    
    obs1.watchEffect((arg1) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg2 = obs2.subscription.callbackArgument as TListenable2;
      final arg3 = obs3.subscription.callbackArgument as AsyncSnapshot<T3>;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs2.watchEffect((arg2) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg3 = obs3.subscription.callbackArgument as AsyncSnapshot<T3>;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs3.watchEffect((arg3) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg2 = obs2.subscription.callbackArgument as TListenable2;
      final arg4 = obs4.subscription.callbackArgument as AsyncSnapshot<T4>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
    obs4.watchEffect((arg4) {
      if (shouldAbortMassEffect4(key, obs1, obs2, obs3, obs4,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as TListenable1;
      final arg2 = obs2.subscription.callbackArgument as TListenable2;
      final arg3 = obs3.subscription.callbackArgument as AsyncSnapshot<T3>;
      effect(arg1, arg2, arg3, arg4);
    }, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    final contextWatch = InheritedContextWatch.of(context);
    
    contextWatch.unwatchEffect(context, $1.of(context), key);
    contextWatch.unwatchEffect(context, $2.of(context), key);
    contextWatch.unwatchEffect(context, $3.of(context), key);
    contextWatch.unwatchEffect(context, $4.of(context), key);
  }
}
