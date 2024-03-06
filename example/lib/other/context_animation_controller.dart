import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class ContextAnimationController extends AnimationController {
  factory ContextAnimationController({
    required BuildContext context,
    double? value,
    Duration? duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) =>
      ContextAnimationController._(
        tickerProvider: _ContextTickerProvider(context),
        value: value,
        duration: duration,
        reverseDuration: reverseDuration,
        debugLabel: debugLabel,
        lowerBound: lowerBound,
        upperBound: upperBound,
        animationBehavior: animationBehavior,
      );

  ContextAnimationController._({
    required _ContextTickerProvider tickerProvider,
    super.value,
    super.duration,
    super.reverseDuration,
    super.debugLabel,
    super.lowerBound,
    super.upperBound,
    super.animationBehavior,
  })  : _tickerProvider = tickerProvider,
        super(vsync: tickerProvider);

  final _ContextTickerProvider _tickerProvider;

  @override
  void dispose() {
    _tickerProvider.dispose();
    super.dispose();
  }
}

class _ContextTickerProvider implements TickerProvider {
  _ContextTickerProvider(this.context);

  final BuildContext context;

  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(onTick);
    _updateTickerModeNotifier();
    _updateTicker(); // Sets _ticker.mute correctly.
    return _ticker!;
  }

  void dispose() {
    _tickerModeNotifier?.removeListener(_updateTicker);
    _tickerModeNotifier = null;
  }

  ValueListenable<bool>? _tickerModeNotifier;

  void _updateTicker() {
    if (_ticker != null) {
      _ticker!.muted = !_tickerModeNotifier!.value;
    }
  }

  void _updateTickerModeNotifier() {
    final ValueListenable<bool> newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTicker);
    newNotifier.addListener(_updateTicker);
    _tickerModeNotifier = newNotifier;
  }
}
