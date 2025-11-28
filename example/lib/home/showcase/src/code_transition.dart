import 'package:example/other/hooks/anim_hooks.dart';
import 'package:flutter/material.dart';

extension CodeIntervalMath on (double begin, double end) {
  List<(double begin, double end)> split(int parts) {
    final part = ($2 - $1) / parts;
    return [for (var i = 0; i < parts; i++) ($1 + i * part, $1 + (i + 1) * part)];
  }
}

extension CodeIntervalsExt on List<(double begin, double end)> {
  (double begin, double end) sub(int start, int end) {
    assert(end >= start, 'end must be greater than or equal to start');
    assert(end < length, 'end must be less than the length of the list');
    return (this[start].$1, this[end].$2);
  }
}

sealed class CodeTransitionConfig {
  const CodeTransitionConfig._({required this.interval, this.curve = Curves.linear});

  final (double begin, double end) interval;
  final Curve curve;

  const factory CodeTransitionConfig.opacity({
    required (double begin, double end) tween,
    required (double begin, double end) interval,
    Curve curve,
  }) = CodeTransitionConfigOpacity;

  const factory CodeTransitionConfig.slide({
    required ((double dx, double dy) begin, (double dx, double dy) end) tween,
    required (double begin, double end) interval,
    Curve curve,
  }) = CodeTransitionConfigSlide;

  const factory CodeTransitionConfig.height({
    required (double begin, double end) tween,
    required (double begin, double end) interval,
    Curve curve,
  }) = CodeTransitionConfigHeight;

  const factory CodeTransitionConfig.width({
    required (double begin, double end) tween,
    required (double begin, double end) interval,
    Curve curve,
  }) = CodeTransitionConfigWidth;
}

class CodeTransitionConfigOpacity extends CodeTransitionConfig {
  const CodeTransitionConfigOpacity({required this.tween, required super.interval, super.curve}) : super._();

  final (double begin, double end) tween;
}

class CodeTransitionConfigSlide extends CodeTransitionConfig {
  const CodeTransitionConfigSlide({required this.tween, required super.interval, super.curve}) : super._();

  final ((double dx, double dy) begin, (double dx, double dy) end) tween;
}

class CodeTransitionConfigHeight extends CodeTransitionConfig {
  const CodeTransitionConfigHeight({required this.tween, required super.interval, super.curve}) : super._();

  final (double begin, double end) tween;
}

class CodeTransitionConfigWidth extends CodeTransitionConfig {
  const CodeTransitionConfigWidth({required this.tween, required super.interval, super.curve}) : super._();

  final (double begin, double end) tween;
}

class CodeTransition extends StatelessWidget {
  const CodeTransition({super.key, required this.anim, required this.config, required this.child});

  final Animation<double> anim;
  final List<CodeTransitionConfig> config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    for (final cfg in config) {
      result = switch (cfg) {
        CodeTransitionConfigOpacity() => FadeTransition(
          opacity: context.useDoubleTweenAnimation(
            key: 'CodeTransitionConfigOpacity',
            anim,
            tween: cfg.tween,
            interval: cfg.interval,
            curve: cfg.curve,
          ),
          child: result,
        ),
        CodeTransitionConfigSlide() => SlideTransition(
          position: context.useOffsetTweenAnimation(
            key: 'CodeTransitionConfigSlide',
            anim,
            tween: cfg.tween,
            interval: cfg.interval,
            curve: cfg.curve,
          ),
          child: result,
        ),
        CodeTransitionConfigHeight() => SizeTransition(
          axis: Axis.vertical,
          sizeFactor: context.useDoubleTweenAnimation(
            key: 'CodeTransitionConfigHeight',
            anim,
            tween: cfg.tween,
            interval: cfg.interval,
            curve: cfg.curve,
          ),
          child: result,
        ),
        CodeTransitionConfigWidth() => SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: context.useDoubleTweenAnimation(
            key: 'CodeTransitionConfigWidth',
            anim,
            tween: cfg.tween,
            interval: cfg.interval,
            curve: cfg.curve,
          ),
          child: result,
        ),
      };
    }

    return result;
  }
}

class CodeColumnTransition extends CodeTransition {
  CodeColumnTransition({super.key, required super.anim, required super.config, required List<Widget> children})
    : super(
        child: Column(crossAxisAlignment: .start, children: children),
      );
}

class CodeRowTransition extends CodeTransition {
  CodeRowTransition({super.key, required super.anim, required super.config, required List<Widget> children})
    : super(child: Row(children: children));
}
