import 'package:flutter/widgets.dart';

import 'src/inherited_context_watch.dart';

R watchOnly2<R, T1, T2, TObs1, TObs2>(
  BuildContext context,
  R Function(T1, T2) selector,
  Object obs1,
  Object obs2,
  T1 defaultValue1,
  T2 defaultValue2,
) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) {
    return selector(defaultValue1, defaultValue2);
  }
  final arg1 = observable1.subscription.callbackArgument as T1;

  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;
  final arg2 = observable2.subscription.callbackArgument as T2;

  final selectedValue = selector(arg1, arg2);
  observable1.watchOnly(
    (arg1) => selector(
      arg1,
      observable2.subscription.callbackArgument as T2,
    ),
    selectedValue,
  );
  observable2.watchOnly(
    (arg2) => selector(
      observable1.subscription.callbackArgument as T1,
      arg2,
    ),
    selectedValue,
  );
  return selectedValue;
}

R watchOnly3<R, T1, T2, T3, TObs1, TObs2, TObs3>(
  BuildContext context,
  R Function(T1, T2, T3) selector,
  Object obs1,
  Object obs2,
  Object obs3,
  T1 defaultValue1,
  T2 defaultValue2,
  T3 defaultValue3,
) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) {
    return selector(defaultValue1, defaultValue2, defaultValue3);
  }
  final arg1 = observable1.subscription.callbackArgument as T1;

  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;
  final arg2 = observable2.subscription.callbackArgument as T2;

  final observable3 = contextWatch.getOrCreateObservable<TObs3>(context, obs3)!;
  final arg3 = observable3.subscription.callbackArgument as T3;

  final selectedValue = selector(arg1, arg2, arg3);
  observable1.watchOnly(
    (arg1) => selector(
      arg1,
      observable2.subscription.callbackArgument as T2,
      observable3.subscription.callbackArgument as T3,
    ),
    selectedValue,
  );
  observable2.watchOnly(
    (arg2) => selector(
      observable1.subscription.callbackArgument as T1,
      arg2,
      observable3.subscription.callbackArgument as T3,
    ),
    selectedValue,
  );
  observable3.watchOnly(
    (arg3) => selector(
      observable1.subscription.callbackArgument as T1,
      observable2.subscription.callbackArgument as T2,
      arg3,
    ),
    selectedValue,
  );
  return selectedValue;
}

R watchOnly4<R, T1, T2, T3, T4, TObs1, TObs2, TObs3, TObs4>(
  BuildContext context,
  R Function(T1, T2, T3, T4) selector,
  Object obs1,
  Object obs2,
  Object obs3,
  Object obs4,
  T1 defaultValue1,
  T2 defaultValue2,
  T3 defaultValue3,
  T4 defaultValue4,
) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) {
    return selector(defaultValue1, defaultValue2, defaultValue3, defaultValue4);
  }
  final arg1 = observable1.subscription.callbackArgument as T1;

  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;
  final arg2 = observable2.subscription.callbackArgument as T2;

  final observable3 = contextWatch.getOrCreateObservable<TObs3>(context, obs3)!;
  final arg3 = observable3.subscription.callbackArgument as T3;

  final observable4 = contextWatch.getOrCreateObservable<TObs4>(context, obs4)!;
  final arg4 = observable4.subscription.callbackArgument as T4;

  final selectedValue = selector(arg1, arg2, arg3, arg4);
  observable1.watchOnly(
    (arg1) => selector(
      arg1,
      observable2.subscription.callbackArgument as T2,
      observable3.subscription.callbackArgument as T3,
      observable4.subscription.callbackArgument as T4,
    ),
    selectedValue,
  );
  observable2.watchOnly(
    (arg2) => selector(
      observable1.subscription.callbackArgument as T1,
      arg2,
      observable3.subscription.callbackArgument as T3,
      observable4.subscription.callbackArgument as T4,
    ),
    selectedValue,
  );
  observable3.watchOnly(
    (arg3) => selector(
      observable1.subscription.callbackArgument as T1,
      observable2.subscription.callbackArgument as T2,
      arg3,
      observable4.subscription.callbackArgument as T4,
    ),
    selectedValue,
  );
  observable4.watchOnly(
    (arg4) => selector(
      observable1.subscription.callbackArgument as T1,
      observable2.subscription.callbackArgument as T2,
      observable3.subscription.callbackArgument as T3,
      arg4,
    ),
    selectedValue,
  );
  return selectedValue;
}

void watchEffect2<T1, T2, TObs1, TObs2>(
  BuildContext context,
  void Function(T1, T2) effect,
  Object obs1,
  Object obs2, {
  Object? key,
  bool immediate = false,
  bool once = false,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) return;
  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;

  observable1.watchEffect((arg1) {
    if (shouldAbortMassEffect2(key, observable1, observable2,
        once: once, immediate: immediate)) {
      return;
    }
    final arg2 = observable2.subscription.callbackArgument as T2;
    effect(arg1, arg2);
  }, key: key, immediate: immediate, once: once);
  observable2.watchEffect((arg2) {
    if (shouldAbortMassEffect2(key, observable1, observable2,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    effect(arg1, arg2);
  }, key: key, immediate: immediate, once: once);
}

void watchEffect3<T1, T2, T3, TObs1, TObs2, TObs3>(
  BuildContext context,
  void Function(T1, T2, T3) effect,
  Object obs1,
  Object obs2,
  Object obs3, {
  Object? key,
  bool immediate = false,
  bool once = false,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) return;
  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;
  final observable3 = contextWatch.getOrCreateObservable<TObs3>(context, obs3)!;

  observable1.watchEffect((arg1) {
    if (shouldAbortMassEffect3(key, observable1, observable2, observable3,
        once: once, immediate: immediate)) {
      return;
    }
    final arg2 = observable2.subscription.callbackArgument as T2;
    final arg3 = observable3.subscription.callbackArgument as T3;
    effect(arg1, arg2, arg3);
  }, key: key, immediate: immediate, once: once);
  observable2.watchEffect((arg2) {
    if (shouldAbortMassEffect3(key, observable1, observable2, observable3,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    final arg3 = observable3.subscription.callbackArgument as T3;
    effect(arg1, arg2, arg3);
  }, key: key, immediate: immediate, once: once);
  observable3.watchEffect((arg3) {
    if (shouldAbortMassEffect3(key, observable1, observable2, observable3,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    final arg2 = observable2.subscription.callbackArgument as T2;
    effect(arg1, arg2, arg3);
  }, key: key, immediate: immediate, once: once);
}

void watchEffect4<T1, T2, T3, T4, TObs1, TObs2, TObs3, TObs4>(
  BuildContext context,
  void Function(T1, T2, T3, T4) effect,
  Object obs1,
  Object obs2,
  Object obs3,
  Object obs4, {
  Object? key,
  bool immediate = false,
  bool once = false,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  final observable1 = contextWatch.getOrCreateObservable<TObs1>(context, obs1);
  if (observable1 == null) return;
  final observable2 = contextWatch.getOrCreateObservable<TObs2>(context, obs2)!;
  final observable3 = contextWatch.getOrCreateObservable<TObs3>(context, obs3)!;
  final observable4 = contextWatch.getOrCreateObservable<TObs4>(context, obs4)!;

  observable1.watchEffect((arg1) {
    if (shouldAbortMassEffect4(
        key, observable1, observable2, observable3, observable4,
        once: once, immediate: immediate)) {
      return;
    }
    final arg2 = observable2.subscription.callbackArgument as T2;
    final arg3 = observable3.subscription.callbackArgument as T3;
    final arg4 = observable4.subscription.callbackArgument as T4;
    effect(arg1, arg2, arg3, arg4);
  }, key: key, immediate: immediate, once: once);
  observable2.watchEffect((arg2) {
    if (shouldAbortMassEffect4(
        key, observable1, observable2, observable3, observable4,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    final arg3 = observable3.subscription.callbackArgument as T3;
    final arg4 = observable4.subscription.callbackArgument as T4;
    effect(arg1, arg2, arg3, arg4);
  }, key: key, immediate: immediate, once: once);
  observable3.watchEffect((arg3) {
    if (shouldAbortMassEffect4(
        key, observable1, observable2, observable3, observable4,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    final arg2 = observable2.subscription.callbackArgument as T2;
    final arg4 = observable4.subscription.callbackArgument as T4;
    effect(arg1, arg2, arg3, arg4);
  }, key: key, immediate: immediate, once: once);
  observable4.watchEffect((arg4) {
    if (shouldAbortMassEffect4(
        key, observable1, observable2, observable3, observable4,
        once: once, immediate: immediate)) {
      return;
    }
    final arg1 = observable1.subscription.callbackArgument as T1;
    final arg2 = observable2.subscription.callbackArgument as T2;
    final arg3 = observable3.subscription.callbackArgument as T3;
    effect(arg1, arg2, arg3, arg4);
  }, key: key, immediate: immediate, once: once);
}

void unwatchEffect2(
  BuildContext context,
  Object obs1,
  Object obs2, {
  required Object key,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  contextWatch.unwatchEffect(context, obs1, key);
  contextWatch.unwatchEffect(context, obs2, key);
}

void unwatchEffect3(
  BuildContext context,
  Object obs1,
  Object obs2,
  Object obs3, {
  required Object key,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  contextWatch.unwatchEffect(context, obs1, key);
  contextWatch.unwatchEffect(context, obs2, key);
  contextWatch.unwatchEffect(context, obs3, key);
}

void unwatchEffect4(
  BuildContext context,
  Object obs1,
  Object obs2,
  Object obs3,
  Object obs4, {
  required Object key,
}) {
  final contextWatch = InheritedContextWatch.of(context);

  contextWatch.unwatchEffect(context, obs1, key);
  contextWatch.unwatchEffect(context, obs2, key);
  contextWatch.unwatchEffect(context, obs3, key);
  contextWatch.unwatchEffect(context, obs4, key);
}

bool shouldAbortMassEffect2(
  Object? key,
  ContextWatchObservable observable1,
  ContextWatchObservable observable2, {
  required bool once,
  required bool immediate,
}) {
  if (once || immediate) {
    final obs1Invoked = observable1.wasEffectInvoked(key!);
    final obs2Invoked = observable2.wasEffectInvoked(key);

    final isAnyInvoked = obs1Invoked || obs2Invoked;
    if (once && isAnyInvoked) {
      return true;
    }
    final isAnyNotInvoked = !obs1Invoked || !obs2Invoked;
    if (immediate && isAnyNotInvoked && isAnyInvoked) {
      return true;
    }
  }
  return false;
}

bool shouldAbortMassEffect3(
  Object? key,
  ContextWatchObservable observable1,
  ContextWatchObservable observable2,
  ContextWatchObservable observable3, {
  required bool once,
  required bool immediate,
}) {
  if (once || immediate) {
    final obs1Invoked = observable1.wasEffectInvoked(key!);
    final obs2Invoked = observable2.wasEffectInvoked(key);
    final obs3Invoked = observable3.wasEffectInvoked(key);

    final isAnyInvoked = obs1Invoked || obs2Invoked || obs3Invoked;
    if (once && isAnyInvoked) {
      return true;
    }
    final isAnyNotInvoked = !obs1Invoked || !obs2Invoked || !obs3Invoked;
    if (immediate && isAnyNotInvoked && isAnyInvoked) {
      return true;
    }
  }
  return false;
}

bool shouldAbortMassEffect4(
  Object? key,
  ContextWatchObservable observable1,
  ContextWatchObservable observable2,
  ContextWatchObservable observable3,
  ContextWatchObservable observable4, {
  required bool once,
  required bool immediate,
}) {
  if (once || immediate) {
    final obs1Invoked = observable1.wasEffectInvoked(key!);
    final obs2Invoked = observable2.wasEffectInvoked(key);
    final obs3Invoked = observable3.wasEffectInvoked(key);
    final obs4Invoked = observable4.wasEffectInvoked(key);

    final isAnyInvoked =
        obs1Invoked || obs2Invoked || obs3Invoked || obs4Invoked;
    if (once && isAnyInvoked) {
      return true;
    }
    final isAnyNotInvoked =
        !obs1Invoked || !obs2Invoked || !obs3Invoked || !obs4Invoked;
    if (immediate && isAnyNotInvoked && isAnyInvoked) {
      return true;
    }
  }
  return false;
}
