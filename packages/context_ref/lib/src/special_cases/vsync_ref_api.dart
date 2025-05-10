import 'package:context_ref/src/value_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../context_ref_root.dart';
import '../ref.dart';

extension AnimationControllerRefAPI<
  TAnimationController extends AnimationController
>
    on Ref<TAnimationController> {
  /// Binds the provided [TAnimationController] to the [context].
  TAnimationController bind(
    BuildContext context,
    TAnimationController Function(TickerProvider vsync) create, {
    void Function(TAnimationController controller)? dispose,
    Object? key,
  }) {
    return _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    ).value;
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the
  /// controller is requested for the first.
  void bindLazy(
    BuildContext context,
    TAnimationController Function(TickerProvider vsync) create, {
    void Function(TAnimationController controller)? dispose,
    Object? key,
  }) {
    _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    );
  }
}

extension NullableAnimationControllerRefAPI<
  TAnimationController extends AnimationController
>
    on Ref<TAnimationController?> {
  /// Optionally binds the provided [TAnimationController] to the [context].
  TAnimationController? bind(
    BuildContext context,
    TAnimationController? Function(TickerProvider vsync) create, {
    void Function(TAnimationController? controller)? dispose,
    Object? key,
  }) {
    return _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    ).value;
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the
  /// controller is requested for the first.
  void bindLazy(
    BuildContext context,
    TAnimationController? Function(TickerProvider vsync) create, {
    void Function(TAnimationController? controller)? dispose,
    Object? key,
  }) {
    _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    );
  }
}

extension TabControllerRefAPI<TTabController extends TabController>
    on Ref<TTabController> {
  /// Binds the provided [TTabController] to the [context].
  TTabController bind(
    BuildContext context,
    TTabController Function(TickerProvider vsync) create, {
    void Function(TTabController controller)? dispose,
    Object? key,
  }) {
    return _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    ).value;
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the
  /// controller is requested for the first.
  void bindLazy(
    BuildContext context,
    TTabController Function(TickerProvider vsync) create, {
    void Function(TTabController controller)? dispose,
    Object? key,
  }) {
    _bindWithVsync(
      ref: this,
      context: context,
      create: create,
      dispose: dispose,
      key: key,
    );
  }
}

ValueProvider<T> _bindWithVsync<T>({
  required Ref<T> ref,
  required BuildContext context,
  required T Function(TickerProvider vsync) create,
  required void Function(T controller)? dispose,
  required Object? key,
}) {
  _SingleTickerProvider? vsync;
  final provider = ContextRefRoot.of(context).bind(
    ref: ref,
    context: context,
    create: () {
      vsync = _SingleTickerProvider();
      vsync!.tickerModeNotifier = TickerMode.getNotifier(context);
      return create(vsync!);
    },
    dispose: (controller) {
      vsync?.dispose();
      if (dispose != null) {
        dispose(controller);
      } else {
        tryDispose(controller);
      }
    },
    key: key,
  );

  // allow `vsync` to properly react to `TickerMode` changes
  vsync?.tickerModeNotifier = TickerMode.getNotifier(context);

  return provider;
}

class _SingleTickerProvider implements TickerProvider {
  Ticker? _ticker;

  ValueListenable<bool>? _tickerModeNotifier;
  set tickerModeNotifier(ValueListenable<bool> notifier) {
    if (notifier == _tickerModeNotifier) return;

    _tickerModeNotifier?.removeListener(_updateTickerMode);
    _tickerModeNotifier = notifier;
    _tickerModeNotifier!.addListener(_updateTickerMode);
    _updateTickerMode();
  }

  void _updateTickerMode() {
    _ticker?.muted = !_tickerModeNotifier!.value;
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(
      _ticker == null,
      'Multiple tickers were requested for the _SingleTickerProvider',
    );
    _ticker = Ticker(
      onTick,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    );
    _updateTickerMode();
    return _ticker!;
  }

  void dispose() {
    _tickerModeNotifier?.removeListener(_updateTickerMode);
  }
}
