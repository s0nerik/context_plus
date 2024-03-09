import 'package:context_ref/src/value_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../context_ref_root.dart';
import '../ref.dart';

extension AnimationControllerRefAPI<
        TAnimationController extends AnimationController>
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

final _isTickerEnabled = Ref<ValueNotifier<bool>>();
ValueProvider<T> _bindWithVsync<T>({
  required Ref<T> ref,
  required BuildContext context,
  required T Function(TickerProvider vsync) create,
  required void Function(T controller)? dispose,
  required Object? key,
}) {
  final shouldEnableTicker = TickerMode.of(context);
  final isTickerEnabled = _isTickerEnabled.bind(
      context, () => ValueNotifier(shouldEnableTicker))
    ..value = shouldEnableTicker;

  _SingleTickerProvider? vsync;
  return ContextRefRoot.of(context).bind(
    ref: ref,
    context: context,
    create: () {
      vsync = _SingleTickerProvider(isTickerEnabled);
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
}

class _SingleTickerProvider implements TickerProvider {
  _SingleTickerProvider(ValueListenable<bool> tickerModeNotifier)
      : _tickerModeNotifier = tickerModeNotifier {
    tickerModeNotifier.addListener(_updateTickerMode);
    _updateTickerMode();
  }

  Ticker? _ticker;
  ValueListenable<bool>? _tickerModeNotifier;

  @override
  Ticker createTicker(TickerCallback onTick) => _ticker ??= Ticker(onTick);

  void dispose() {
    _tickerModeNotifier?.removeListener(_updateTickerMode);
    _tickerModeNotifier = null;
  }

  void _updateTickerMode() {
    if (_ticker != null) {
      _ticker!.muted = !_tickerModeNotifier!.value;
    }
  }
}
