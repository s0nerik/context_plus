import 'src/inherited_context_watch.dart';

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

bool shouldAbortMassEffect5(
  Object? key,
  ContextWatchObservable observable1,
  ContextWatchObservable observable2,
  ContextWatchObservable observable3,
  ContextWatchObservable observable4,
  ContextWatchObservable observable5, {
  required bool once,
  required bool immediate,
}) {
  if (once || immediate) {
    final obs1Invoked = observable1.wasEffectInvoked(key!);
    final obs2Invoked = observable2.wasEffectInvoked(key);
    final obs3Invoked = observable3.wasEffectInvoked(key);
    final obs4Invoked = observable4.wasEffectInvoked(key);
    final obs5Invoked = observable5.wasEffectInvoked(key);

    final isAnyInvoked =
        obs1Invoked || obs2Invoked || obs3Invoked || obs4Invoked || obs5Invoked;
    if (once && isAnyInvoked) {
      return true;
    }
    final isAnyNotInvoked = !obs1Invoked ||
        !obs2Invoked ||
        !obs3Invoked ||
        !obs4Invoked ||
        !obs5Invoked;
    if (immediate && isAnyNotInvoked && isAnyInvoked) {
      return true;
    }
  }
  return false;
}
