// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch_base/context_watch_base.dart';
import 'package:context_watch_base/watch_callback_record_util.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchCallbackRecordRefExt22<T1, T2, TListenable3 extends Listenable> on (context_ref.ReadOnlyRef<Future<T1>>, context_ref.ReadOnlyRef<Future<T2>>, context_ref.ReadOnlyRef<TListenable3>) {
  /// {@macro mass_watch_only_explanation}
  R watchOnly<R>(
    BuildContext context,
    R Function(AsyncSnapshot<T1>, AsyncSnapshot<T2>, TListenable3) selector,
  ) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final observable1 = contextWatch.getOrCreateObservable<T1>(context, $1);
    if (observable1 == null) return selector(AsyncSnapshot<T1>.nothing(), AsyncSnapshot<T2>.nothing(), $3.of(context));
    final arg1 = observable1.subscription.callbackArgument as AsyncSnapshot<T1>;

    final observable2 = contextWatch.getOrCreateObservable<T2>(context, $2)!;
    final arg2 = observable2.subscription.callbackArgument as AsyncSnapshot<T2>;

    final observable3 = contextWatch.getOrCreateObservable(context, $3)!;
    final arg3 = observable3.subscription.callbackArgument as TListenable3;
    
    final selectedValue = selector(arg1, arg2, arg3);
    observable1.watchOnly(
      (arg1) => selector(
        arg1,
        observable2.subscription.callbackArgument as AsyncSnapshot<T2>,
        observable3.subscription.callbackArgument as TListenable3,
      ),
      selectedValue,
    );
    observable2.watchOnly(
      (arg2) => selector(
        observable1.subscription.callbackArgument as AsyncSnapshot<T1>,
        arg2,
        observable3.subscription.callbackArgument as TListenable3,
      ),
      selectedValue,
    );
    observable3.watchOnly(
      (arg3) => selector(
        observable1.subscription.callbackArgument as AsyncSnapshot<T1>,
        observable2.subscription.callbackArgument as AsyncSnapshot<T2>,
        arg3,
      ),
      selectedValue,
    );
    
    return selectedValue;
  }

  /// {@macro mass_watch_effect_explanation}
  void watchEffect(
    BuildContext context,
    void Function(AsyncSnapshot<T1>, AsyncSnapshot<T2>, TListenable3) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    final contextWatch = InheritedContextWatch.of(context);
    
    final obs1 = contextWatch.getOrCreateObservable<T1>(context, $1.of(context));
    if (obs1 == null) return;
    final obs2 = contextWatch.getOrCreateObservable<T2>(context, $2.of(context))!;
    final obs3 = contextWatch.getOrCreateObservable(context, $3.of(context))!;
    
    obs1.watchEffect((arg1) {
      if (shouldAbortMassEffect3(key, obs1, obs2, obs3,
          once: once, immediate: immediate)) {
        return;
      }
      final arg2 = obs2.subscription.callbackArgument as AsyncSnapshot<T2>;
      final arg3 = obs3.subscription.callbackArgument as TListenable3;
      effect(arg1, arg2, arg3);
    }, key: key, immediate: immediate, once: once);
    obs2.watchEffect((arg2) {
      if (shouldAbortMassEffect3(key, obs1, obs2, obs3,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as AsyncSnapshot<T1>;
      final arg3 = obs3.subscription.callbackArgument as TListenable3;
      effect(arg1, arg2, arg3);
    }, key: key, immediate: immediate, once: once);
    obs3.watchEffect((arg3) {
      if (shouldAbortMassEffect3(key, obs1, obs2, obs3,
          once: once, immediate: immediate)) {
        return;
      }
      final arg1 = obs1.subscription.callbackArgument as AsyncSnapshot<T1>;
      final arg2 = obs2.subscription.callbackArgument as AsyncSnapshot<T2>;
      effect(arg1, arg2, arg3);
    }, key: key, immediate: immediate, once: once);
  }
  
  /// {@macro mass_unwatch_effect_explanation}
  void unwatchEffect(BuildContext context, {required Object key}) {
    final contextWatch = InheritedContextWatch.of(context);
    
    contextWatch.unwatchEffect(context, $1.of(context), key);
    contextWatch.unwatchEffect(context, $2.of(context), key);
    contextWatch.unwatchEffect(context, $3.of(context), key);
  }
}
