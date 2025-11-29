import 'package:context_plus/context_plus.dart';
import 'package:example/home/widgets/replace_transition.dart';
import 'package:example/home/widgets/reverse_flex_transition.dart';
import 'package:flutter/material.dart';

import 'code_transition.dart';

class CodeAnimationController extends AnimationController {
  CodeAnimationController(TickerProvider vsync) : super(vsync: vsync) {
    addListener(_onProgress);
  }

  bool _reachedLastStep = false;
  bool get reachedLastStep => _reachedLastStep;
  void _onProgress() {
    _reachedLastStep = _reachedLastStep || value * Code.steps >= Code.steps - 1;
  }

  double get currentStep => (value * (Code.steps - 1)).clamp(0, Code.steps - 1);

  double stepProgress(int step) {
    const totalSegments = Code.steps - 1;
    if (totalSegments <= 0) {
      return step == 0 ? 1.0 : 0.0;
    }

    final controllerSpan = upperBound - lowerBound;
    final clampedSpan = controllerSpan == 0 ? 1.0 : controllerSpan;
    // Map the controller value to the step space so each step eases in/out smoothly.
    final normalizedValue = ((value - lowerBound) / clampedSpan).clamp(0.0, 1.0);
    final stepPosition = normalizedValue * totalSegments;
    final distance = (stepPosition - step).abs();

    if (distance >= 1) {
      return 0.0;
    }
    return 1 - distance;
  }

  Object? _currentAnimateToStepToken;
  Future<void> animateToStep(int step) {
    assert(step >= 0 && step <= Code.steps - 1, 'step must be between 0 and Code.steps - 1');

    final token = Object();
    _currentAnimateToStepToken = token;

    final currStep = currentStep.toInt();
    if ((currStep - step).abs() <= 1) {
      const fullDuration = Duration(milliseconds: 1000);
      final progressLeft = (currentStep - step).abs();
      final duration = fullDuration * progressLeft;
      return super.animateTo(step / (Code.steps - 1), duration: duration)..whenCompleteOrCancel(() {
        _currentAnimateToStepToken = null;
      });
    } else if (currStep < step) {
      return animateToStep(currStep + 1).then((_) {
        if (_currentAnimateToStepToken != token || _currentAnimateToStepToken == null) return Future.value();
        return animateToStep(step);
      });
    } else {
      return animateToStep(currStep - 1).then((_) {
        if (_currentAnimateToStepToken != token || _currentAnimateToStepToken == null) return Future.value();
        return animateToStep(step);
      });
    }
  }

  @override
  TickerFuture animateTo(double target, {Duration? duration, Curve curve = Curves.linear}) {
    throw UnimplementedError('animateToStep is not supported for CodeAnimationController');
  }
}

class Code extends StatelessWidget {
  const Code({super.key, required this.controller});

  final CodeAnimationController controller;

  static const steps = 4;
  static final _animController = Ref<CodeAnimationController>();

  @override
  Widget build(BuildContext context) {
    _animController.bindValue(context, controller);

    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 9, letterSpacing: 0.6),
      child: _Code(controller: controller),
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({required this.controller});

  final CodeAnimationController controller;

  @override
  Widget build(BuildContext context) {
    final intervals = (0.0, 1.0).split(Code.steps - 1);

    var (start, end) = (0, 0);

    // Step 1: Create a Ref
    final createRefIntervals = intervals[0].split(7);
    // _InheritedState fade out
    (start, end) = (0, 2);
    final inheritedStateClassOpacityFadeInterval = createRefIntervals.sub(start, end);
    final inheritedStateMethodsOpacityFadeInterval = createRefIntervals.sub(start, end);
    // _InheritedState collapse
    (start, end) = (3, 3);
    final inheritedStateClassHeightCollapseInterval = createRefIntervals.sub(start, end);
    final inheritedStateMethodsHeightCollapseInterval = createRefIntervals.sub(start, end);
    final inheritedStateScaleControllerIndentWidthCollapseInterval = createRefIntervals.sub(start, end);
    final inheritedStateColorStreamIndentWidthCollapseInterval = createRefIntervals.sub(start, end);
    // _scaleController (1)
    (start, end) = (2, 3);
    final refDefinitionScaleControllerSwapInterval = createRefIntervals.sub(start, end);
    // _scaleController (2)
    (start, end) = (3, 3);
    final refDefinitionScaleControllerAssignmentWidthInterval = createRefIntervals.sub(start, end);
    final refDefinitionScaleControllerVariableUnderscoreWidthInterval = createRefIntervals.sub(start, end);
    final refDefinitionScaleControllerVariableUnderscoreHeightInterval = createRefIntervals.sub(start, end);
    final refDefinitionScaleControllerRefTypeWidthInterval = createRefIntervals.sub(start, end);
    // _scaleController (3)
    (start, end) = (3, 4);
    final refDefinitionScaleControllerAssignmentOpacityInterval = createRefIntervals.sub(start, end);
    final refDefinitionScaleControllerAssignmentSlideInterval = createRefIntervals.sub(start, end);
    // _scaleController (4)
    (start, end) = (4, 5);
    final refDefinitionScaleControllerRefTypeOpacityInterval = createRefIntervals.sub(start, end);
    final refDefinitionScaleControllerRefTypeSlideInterval = createRefIntervals.sub(start, end);
    // _colorStream (1)
    (start, end) = (2, 3);
    final refDefinitionColorStreamSwapInterval = createRefIntervals.sub(start, end);
    // _colorStream (2)
    (start, end) = (4, 4);
    final refDefinitionColorStreamAssignmentWidthInterval = createRefIntervals.sub(start, end);
    final refDefinitionColorStreamVariableUnderscoreWidthInterval = createRefIntervals.sub(start, end);
    final refDefinitionColorStreamVariableUnderscoreHeightInterval = createRefIntervals.sub(start, end);
    final refDefinitionColorStreamRefTypeWidthInterval = createRefIntervals.sub(start, end);
    // _colorStream (3)
    (start, end) = (4, 5);
    final refDefinitionColorStreamAssignmentOpacityInterval = createRefIntervals.sub(start, end);
    final refDefinitionColorStreamAssignmentSlideInterval = createRefIntervals.sub(start, end);
    // _colorStream (4)
    (start, end) = (5, 6);
    final refDefinitionColorStreamRefTypeOpacityInterval = createRefIntervals.sub(start, end);
    final refDefinitionColorStreamRefTypeSlideInterval = createRefIntervals.sub(start, end);

    // Step 2: bind() it to a BuildContext
    final bindContextIntervals = intervals[1].split(8);
    // class Example extends StatelessWidget {
    (start, end) = (0, 0);
    final exampleWidgetTypeTransitionInterval = bindContextIntervals.sub(start, end);
    // StatefulWidget code fade out
    (start, end) = (1, 1);
    final exampleStateCodeCreateStateOpacityFadeInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeColorStreamVariableOpacityFadeInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeScaleControllerVariableOpacityFadeInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeDisposeOpacityFadeInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnInheritedStateOpacityFadeInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnAnimatedLogoOpacityFadeInterval = bindContextIntervals.sub(start, end);
    // Shrink height and transition the code
    (start, end) = (2, 4);
    final exampleStateCodeCreateStateHeightCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeReverseFlexTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeVariableIndentWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeColorStreamVariableWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeColorStreamVariableReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeScaleControllerVariableWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeScaleControllerVariableReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeScaleControllerParameterColumnHeightExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeAnimationControllerIndentReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeAnimationControllerIndentWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeVsyncParameterIndentWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeDurationParameterIndentWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeRepeatParameterIndentWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeDisposeHeightCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnInheritedStateHeightCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnAnimatedLogoHeightCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnAnimatedLogoIndentReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeBuildReturnAnimatedLogoCommaReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    // Prepare extra height for future bind() method call params
    final exampleStateCodeAnimationControllerColumnHeightExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeSemicolonHeightExpandInterval = bindContextIntervals.sub(start, end);
    // Introduce bind() method calls
    (start, end) = (5, 6);
    final exampleStateCodeColorStreamBindMethodReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeColorStreamBindMethodReplaceTransitionClosingInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeScaleControllerBindMethodReplaceTransitionInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeAnimationControllerBindMethodWidthCollapseInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeVsyncParameterIndentWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeDurationParameterIndentWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeRepeatParameterIndentWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeSemicolonWidthExpandInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeSemicolonOpacityExpandInterval = bindContextIntervals.sub(start, end);
    // Animate bind() method parameters
    (start, end) = (6, 6);
    final exampleStateCodeContextParameterOpacitySlideInInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeContextParameterSlideInInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeAnimationControllerColumnOpacitySlideInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeAnimationControllerColumnSlideInterval = bindContextIntervals.sub(start, end);
    // Animate `(vsync) => ` within the bind() call
    (start, end) = (7, 7);
    final exampleStateCodeVsyncParameterOpacitySlideInInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeVsyncParameterSlideInInterval = bindContextIntervals.sub(start, end);
    final exampleStateCodeVsyncParameterReplaceTransitionInterval = bindContextIntervals.sub(start, end);

    // Step 3: .watch() it from a BuildContext
    final watchContextIntervals = intervals[2].split(4);
    // Fade out the StreamBuilder / ValueListenableBuilder implementation.
    (start, end) = (0, 0);
    final logoOldCodeOpacityFadeInterval = watchContextIntervals.sub(start, end);
    // Collapse the old code block while swapping in context_plus helpers.
    (start, end) = (1, 1);
    final logoOldCodeHeightCollapseInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeColumnHeightCollapseInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeColumnOpacityCollapseInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeTransformIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeScaleIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeChildIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeSizeIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeStyleIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeTextColorIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeClosingParenIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeClosingParenSecondIndentReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    final logoOldCodeClosingParenCommaReplaceTransitionInterval = watchContextIntervals.sub(start, end);
    // Introduce watch() replacements for scale/color streams.
    (start, end) = (2, 2);
    final logoScaleVariableTransitionInterval = watchContextIntervals.sub(start, end);
    // Introduce watch() replacements for color stream.
    (start, end) = (3, 3);
    final logoColorStreamTransitionInterval = watchContextIntervals.sub(start, end);

    final code = Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        //
        // ***************************************************
        //
        // _InheritedWidget
        //
        // ***************************************************
        //
        CodeColumnTransition(
          anim: controller,
          config: [
            .opacity(tween: (1, 0), interval: inheritedStateClassOpacityFadeInterval),
            .height(tween: (1, 0), interval: inheritedStateClassHeightCollapseInterval),
          ],
          children: const [
            Row(
              children: [
                _Identifier('class', .keyword),
                _Identifier(' ', .other),
                _Identifier('_InheritedState', .type),
                _Identifier(' ', .other),
                _Identifier('extends', .keyword),
                _Identifier(' ', .other),
                _Identifier('InheritedWidget', .type),
                _Identifier(' ', .other),
                _Identifier('{', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('  const', .keyword),
                _Identifier(' ', .other),
                _Identifier('_InheritedState', .type),
                _Identifier('({', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('    required', .keyword),
                _Identifier(' ', .other),
                _Identifier('this', .keyword),
                _Identifier('.', .other),
                _Identifier('scaleController', .variable),
                _Identifier(',', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('    required', .keyword),
                _Identifier(' ', .other),
                _Identifier('this', .keyword),
                _Identifier('.', .other),
                _Identifier('colorStream', .variable),
                _Identifier(',', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('    required', .keyword),
                _Identifier(' ', .other),
                _Identifier('super', .keyword),
                _Identifier('.', .other),
                _Identifier('child', .variable),
                _Identifier(',', .other),
              ],
            ),
            _Identifier('  })', .other),
            _Identifier('', .other),
          ],
        ),
        // _scaleController
        Row(
          children: [
            CodeTransition(
              anim: controller,
              config: [.width(tween: (1, 0), interval: inheritedStateScaleControllerIndentWidthCollapseInterval)],
              child: const _Identifier('  ', .other),
            ),
            const _Identifier('final', .keyword),
            const _Identifier(' ', .other),
            ReverseFlexTransition(
              animation: controller,
              curveOffset: 0.05,
              interval: refDefinitionScaleControllerSwapInterval,
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    CodeTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionScaleControllerAssignmentWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionScaleControllerAssignmentOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionScaleControllerAssignmentSlideInterval),
                      ],
                      child: const _Identifier('= ', .other),
                    ),
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionScaleControllerRefTypeWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionScaleControllerRefTypeOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionScaleControllerRefTypeSlideInterval),
                      ],
                      children: const [_Identifier('Ref', .callable), _Identifier('<', .other)],
                    ),
                    const _Identifier('AnimationController', .type),
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionScaleControllerRefTypeWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionScaleControllerRefTypeOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionScaleControllerRefTypeSlideInterval),
                      ],
                      children: const [_Identifier('>()', .other)],
                    ),
                  ],
                ),
                const _Identifier(' ', .other),
                Row(
                  children: [
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionScaleControllerVariableUnderscoreWidthInterval),
                        .height(tween: (0, 1), interval: refDefinitionScaleControllerVariableUnderscoreHeightInterval),
                      ],
                      children: const [_Identifier('_', .variable)],
                    ),
                    const _Identifier('scaleController', .variable),
                  ],
                ),
              ],
            ),
            const _Identifier(';', .other),
          ],
        ),
        // _colorStream,
        Row(
          children: [
            CodeTransition(
              anim: controller,
              config: [.width(tween: (1, 0), interval: inheritedStateColorStreamIndentWidthCollapseInterval)],
              child: const _Identifier('  ', .other),
            ),
            const _Identifier('final', .keyword),
            const _Identifier(' ', .other),
            ReverseFlexTransition(
              animation: controller,
              curveOffset: 0.05,
              interval: refDefinitionColorStreamSwapInterval,
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    CodeTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionColorStreamAssignmentWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionColorStreamAssignmentOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionColorStreamAssignmentSlideInterval),
                      ],
                      child: const _Identifier('= ', .other),
                    ),
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionColorStreamRefTypeWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionColorStreamRefTypeOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionColorStreamRefTypeSlideInterval),
                      ],
                      children: const [_Identifier('Ref', .callable), _Identifier('<', .other)],
                    ),
                    const _Identifier('Stream', .type),
                    const _Identifier('<', .other),
                    const _Identifier('Color', .type),
                    const _Identifier('>', .other),
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionColorStreamRefTypeWidthInterval),
                        .opacity(tween: (0, 1), interval: refDefinitionColorStreamRefTypeOpacityInterval),
                        .slide(tween: ((0, 1), (0, 0)), interval: refDefinitionColorStreamRefTypeSlideInterval),
                      ],
                      children: const [_Identifier('>()', .other)],
                    ),
                  ],
                ),
                const _Identifier(' ', .other),
                Row(
                  children: [
                    CodeRowTransition(
                      anim: controller,
                      config: [
                        .width(tween: (0, 1), interval: refDefinitionColorStreamVariableUnderscoreWidthInterval),
                        .height(tween: (0, 1), interval: refDefinitionColorStreamVariableUnderscoreHeightInterval),
                      ],
                      children: const [_Identifier('_', .variable)],
                    ),
                    const _Identifier('colorStream', .variable),
                  ],
                ),
              ],
            ),
            const _Identifier(';', .other),
          ],
        ),
        // inherited widget methods
        CodeColumnTransition(
          anim: controller,
          config: [
            .opacity(tween: (1, 0), interval: inheritedStateMethodsOpacityFadeInterval),
            .height(tween: (1, 0), interval: inheritedStateMethodsHeightCollapseInterval),
          ],
          children: const [
            _Identifier('', .other),
            _Identifier('  @override', .annotation),
            Row(
              children: [
                _Identifier('  bool', .type),
                _Identifier(' ', .other),
                _Identifier('updateShouldNotify', .callable),
                _Identifier('(', .other),
                _Identifier('_InheritedState', .type),
                _Identifier(' oldWidget', .variable),
                _Identifier(')', .other),
                _Identifier(' =>', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('      oldWidget', .variable),
                _Identifier('.', .other),
                _Identifier('scaleController', .instanceVariable),
                _Identifier(' != ', .other),
                _Identifier('scaleController', .instanceVariable),
                _Identifier(' ||', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('      oldWidget', .variable),
                _Identifier('.', .other),
                _Identifier('colorStream', .instanceVariable),
                _Identifier(' != ', .other),
                _Identifier('colorStream', .instanceVariable),
                _Identifier(';', .other),
              ],
            ),
            _Identifier('', .other),
            Row(
              children: [
                _Identifier('  static', .keyword),
                _Identifier(' ', .other),
                _Identifier('_InheritedState', .type),
                _Identifier(' ', .other),
                _Identifier('of', .variable),
                _Identifier('(', .other),
                _Identifier('BuildContext', .type),
                _Identifier(' ', .other),
                _Identifier('context', .variable),
                _Identifier(')', .other),
                _Identifier(' =>', .other),
              ],
            ),
            Row(
              children: [
                _Identifier('      context', .variable),
                _Identifier('.', .other),
                _Identifier('dependOnInheritedWidgetOfExactType', .callable),
                _Identifier('<', .other),
                _Identifier('_InheritedState', .type),
                _Identifier('>', .other),
                _Identifier('()!;', .other),
              ],
            ),
            _Identifier('}', .other),
          ],
        ),
        const _Identifier('', .other),
        //
        // ***************************************************
        //
        // ExampleWidget
        //
        // ***************************************************
        //
        // class Example extends StatelessWidget {
        Row(
          children: [
            const _Identifier('class', .keyword),
            const _Identifier(' ', .other),
            const _Identifier('Example', .type),
            const _Identifier(' ', .other),
            const _Identifier('extends', .keyword),
            const _Identifier(' ', .other),
            ReplaceTransition(
              animation: controller,
              interval: exampleWidgetTypeTransitionInterval,
              prevChild: const _Identifier('StatefulWidget', .type),
              child: const _Identifier('StatelessWidget', .type),
            ),
            const _Identifier(' ', .other),
            const _Identifier('{', .other),
          ],
        ),
        // const Example({super.key});
        const Row(
          children: [
            _Identifier('  const', .keyword),
            _Identifier(' ', .other),
            _Identifier('Example', .type),
            _Identifier('({', .other),
            _Identifier('super', .keyword),
            _Identifier('.', .other),
            _Identifier('key', .variable),
            _Identifier('});', .other),
          ],
        ),
        const _Identifier('', .other),
        ReverseFlexTransition(
          animation: controller,
          curveOffset: -0.1,
          interval: exampleStateCodeReverseFlexTransitionInterval,
          direction: Axis.vertical,
          crossAxisAlignment: .start,
          children: [
            // createState
            Column(
              crossAxisAlignment: .start,
              children: [
                // removable state
                CodeColumnTransition(
                  anim: controller,
                  config: [
                    .opacity(tween: (1, 0), interval: exampleStateCodeCreateStateOpacityFadeInterval),
                    .height(tween: (1, 0), interval: exampleStateCodeCreateStateHeightCollapseInterval),
                  ],
                  children: const [
                    _Identifier('  @override', .annotation),
                    Row(
                      children: [
                        _Identifier('  State', .type),
                        _Identifier('<', .other),
                        _Identifier('Example', .type),
                        _Identifier('>', .other),
                        _Identifier(' ', .other),
                        _Identifier('createState', .callable),
                        _Identifier('() => ', .other),
                        _Identifier('_ExampleState', .callable),
                        _Identifier('();', .other),
                      ],
                    ),
                    _Identifier('}', .other),
                    _Identifier('', .other),
                    Row(
                      children: [
                        _Identifier('class', .keyword),
                        _Identifier(' ', .other),
                        _Identifier('_ExampleState', .type),
                        _Identifier(' ', .other),
                        _Identifier('extends', .keyword),
                        _Identifier(' ', .other),
                        _Identifier('State', .type),
                        _Identifier('<', .other),
                        _Identifier('Example', .type),
                        _Identifier('>', .other),
                        _Identifier(' ', .other),
                        _Identifier('with', .keyword),
                        _Identifier(' ', .other),
                        _Identifier('SingleTickerProviderStateMixin', .type),
                        _Identifier(' {', .other),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // variable indentation
                    CodeRowTransition(
                      anim: controller,
                      config: [.width(tween: (0, 1), interval: exampleStateCodeVariableIndentWidthExpandInterval)],
                      children: const [_Identifier('    ', .other)],
                    ),
                    // variable declarations
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        // _colorStream
                        Row(
                          children: [
                            CodeRowTransition(
                              anim: controller,
                              config: [
                                .opacity(
                                  tween: (1, 0),
                                  interval: exampleStateCodeColorStreamVariableOpacityFadeInterval,
                                ),
                                .width(
                                  tween: (1, 0),
                                  interval: exampleStateCodeColorStreamVariableWidthCollapseInterval,
                                ),
                              ],
                              children: [
                                ReplaceTransition(
                                  animation: controller,
                                  interval: exampleStateCodeColorStreamVariableReplaceTransitionInterval,
                                  prevChild: const _Identifier('  ', .other),
                                  child: const _Identifier('', .other),
                                ),
                                const _Identifier('late final', .keyword),
                                const _Identifier(' ', .other),
                                const _Identifier('Stream', .type),
                                const _Identifier('<', .other),
                                const _Identifier('Color', .type),
                                const _Identifier('>', .other),
                                const _Identifier(' ', .other),
                              ],
                            ),
                            const _Identifier('_colorStream', .variable),
                            ReplaceTransition(
                              animation: controller,
                              interval: exampleStateCodeColorStreamBindMethodReplaceTransitionInterval,
                              prevChild: const _Identifier(' = ', .other),
                              child: const Row(
                                children: [
                                  _Identifier('.', .other),
                                  _Identifier('bind', .callable),
                                  _Identifier('(', .other),
                                  _Identifier('context', .variable),
                                  _Identifier(', ', .other),
                                ],
                              ),
                            ),
                            const _Identifier('createColorStream', .callable),
                            ReplaceTransition(
                              animation: controller,
                              interval: exampleStateCodeColorStreamBindMethodReplaceTransitionClosingInterval,
                              prevChild: const _Identifier('(', .other),
                              child: const _Identifier('', .other),
                            ),
                            const _Identifier(');', .other),
                          ],
                        ),
                        // _scaleController = ...
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // late final AnimationController _scaleController = ...
                            Row(
                              children: [
                                CodeRowTransition(
                                  anim: controller,
                                  config: [
                                    .opacity(
                                      tween: (1, 0),
                                      interval: exampleStateCodeScaleControllerVariableOpacityFadeInterval,
                                    ),
                                    .width(
                                      tween: (1, 0),
                                      interval: exampleStateCodeScaleControllerVariableWidthCollapseInterval,
                                    ),
                                  ],
                                  children: [
                                    ReplaceTransition(
                                      animation: controller,
                                      interval: exampleStateCodeScaleControllerVariableReplaceTransitionInterval,
                                      prevChild: const _Identifier('  ', .other),
                                      child: const _Identifier('', .other),
                                    ),
                                    const _Identifier('late final ', .keyword),
                                    const _Identifier('AnimationController', .type),
                                    const _Identifier(' ', .other),
                                  ],
                                ),
                                const _Identifier('_scaleController', .variable),
                                // = ... / .bind(
                                ReplaceTransition(
                                  animation: controller,
                                  interval: exampleStateCodeScaleControllerBindMethodReplaceTransitionInterval,
                                  prevChild: const _Identifier(' = ', .other),
                                  child: const Row(
                                    children: [
                                      _Identifier('.', .other),
                                      _Identifier('bind', .callable),
                                      _Identifier('(', .other),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //   context,
                            //   (vsync) => ...
                            CodeColumnTransition(
                              anim: controller,
                              config: [
                                .height(
                                  tween: (0, 1),
                                  interval: exampleStateCodeScaleControllerParameterColumnHeightExpandInterval,
                                ),
                              ],
                              children: [
                                const _Identifier('', .other),
                                CodeRowTransition(
                                  anim: controller,
                                  config: [
                                    .opacity(
                                      tween: (0, 1),
                                      interval: exampleStateCodeContextParameterOpacitySlideInInterval,
                                    ),
                                    .slide(
                                      tween: ((0, 0.15), (0, 0)),
                                      interval: exampleStateCodeContextParameterSlideInInterval,
                                    ),
                                  ],
                                  children: const [_Identifier('  context', .variable), _Identifier(',', .other)],
                                ),
                                CodeRowTransition(
                                  anim: controller,
                                  config: [
                                    .opacity(
                                      tween: (0, 1),
                                      interval: exampleStateCodeVsyncParameterOpacitySlideInInterval,
                                    ),
                                    .slide(
                                      tween: ((0, 0.15), (0, 0)),
                                      interval: exampleStateCodeVsyncParameterSlideInInterval,
                                    ),
                                  ],
                                  children: const [
                                    _Identifier('  ', .other),
                                    _Identifier('(', .other),
                                    _Identifier('vsync', .variable),
                                    _Identifier(') => ', .other),
                                  ],
                                ),
                              ],
                            ),
                            //              AnimationController(
                            //     vsync: ...,
                            //     duration: const Duration(seconds: 1),
                            // )..repeat(min: 0.5, max: 1, reverse: true),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                CodeColumnTransition(
                                  anim: controller,
                                  config: [
                                    .height(
                                      tween: (0, 1),
                                      interval: exampleStateCodeAnimationControllerColumnHeightExpandInterval,
                                    ),
                                    .opacity(
                                      tween: (0, 1),
                                      interval: exampleStateCodeAnimationControllerColumnOpacitySlideInterval,
                                    ),
                                    .slide(
                                      tween: ((0, 1), (0, 0)),
                                      interval: exampleStateCodeAnimationControllerColumnSlideInterval,
                                    ),
                                  ],
                                  children: const [_Identifier('', .other), _Identifier('', .other)],
                                ),
                                // late final AnimationController _scaleController = AnimationController(
                                Row(
                                  children: [
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (1, 0),
                                          interval: exampleStateCodeAnimationControllerBindMethodWidthCollapseInterval,
                                        ),
                                      ],
                                      child: ReplaceTransition(
                                        animation: controller,
                                        interval: exampleStateCodeAnimationControllerIndentReplaceTransitionInterval,
                                        prevChild: const _Identifier(
                                          '                                                    ',
                                          .other,
                                        ),
                                        child: const _Identifier('      ', .other),
                                      ),
                                    ),
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (0, 1),
                                          interval: exampleStateCodeAnimationControllerIndentWidthExpandInterval,
                                        ),
                                      ],
                                      child: const _Identifier('             ', .other),
                                    ),
                                    const _Identifier('AnimationController', .callable),
                                    const _Identifier('(', .other),
                                  ],
                                ),
                                //   vsync: this,
                                Row(
                                  children: [
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (1, 0),
                                          interval: exampleStateCodeVsyncParameterIndentWidthCollapseInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (0, 1),
                                          interval: exampleStateCodeVsyncParameterIndentWidthExpandInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    const _Identifier('  vsync', .variable),
                                    const _Identifier(': ', .other),
                                    ReplaceTransition(
                                      animation: controller,
                                      interval: exampleStateCodeVsyncParameterReplaceTransitionInterval,
                                      prevChild: const _Identifier('this', .keyword),
                                      child: const _Identifier('vsync', .variable),
                                    ),
                                    const _Identifier(',', .other),
                                  ],
                                ),
                                //   duration: const Duration(seconds: 1),
                                Row(
                                  children: [
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (1, 0),
                                          interval: exampleStateCodeDurationParameterIndentWidthCollapseInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (0, 1),
                                          interval: exampleStateCodeDurationParameterIndentWidthExpandInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    const _Identifier('  duration', .variable),
                                    const _Identifier(': ', .other),
                                    const _Identifier('const ', .keyword),
                                    const _Identifier('Duration', .callable),
                                    const _Identifier('(', .other),
                                    const _Identifier('seconds', .variable),
                                    const _Identifier(': ', .other),
                                    const _Identifier('1', .number),
                                    const _Identifier('),', .other),
                                  ],
                                ),
                                // )..repeat(min: 0.5, max: 1, reverse: true),
                                Row(
                                  children: [
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (1, 0),
                                          interval: exampleStateCodeRepeatParameterIndentWidthCollapseInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    CodeTransition(
                                      anim: controller,
                                      config: [
                                        .width(
                                          tween: (0, 1),
                                          interval: exampleStateCodeRepeatParameterIndentWidthExpandInterval,
                                        ),
                                      ],
                                      child: const _Identifier('  ', .other),
                                    ),
                                    const _Identifier(')..', .other),
                                    const _Identifier('repeat', .callable),
                                    const _Identifier('(', .other),
                                    const _Identifier('min', .variable),
                                    const _Identifier(': ', .other),
                                    const _Identifier('0.5', .number),
                                    const _Identifier(', ', .other),
                                    const _Identifier('max', .variable),
                                    const _Identifier(': ', .other),
                                    const _Identifier('1', .number),
                                    const _Identifier(', ', .other),
                                    const _Identifier('reverse', .variable),
                                    const _Identifier(': ', .other),
                                    const _Identifier('true', .keyword),
                                    const _Identifier('),', .other),
                                  ],
                                ),
                                // );
                                CodeTransition(
                                  anim: controller,
                                  config: [
                                    .width(tween: (0, 1), interval: exampleStateCodeSemicolonWidthExpandInterval),
                                    .height(tween: (0, 1), interval: exampleStateCodeSemicolonHeightExpandInterval),
                                    .opacity(tween: (0, 1), interval: exampleStateCodeSemicolonOpacityExpandInterval),
                                  ],
                                  child: const _Identifier(');', .other),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // dispose
                CodeColumnTransition(
                  anim: controller,
                  config: [
                    .opacity(tween: (1, 0), interval: exampleStateCodeDisposeOpacityFadeInterval),
                    .height(tween: (1, 0), interval: exampleStateCodeDisposeHeightCollapseInterval),
                  ],
                  children: const [
                    _Identifier('', .other),
                    _Identifier('  @override', .annotation),
                    Row(
                      children: [
                        _Identifier('  void', .keyword),
                        _Identifier(' ', .other),
                        _Identifier('dispose', .callable),
                        _Identifier('() {', .other),
                      ],
                    ),
                    Row(
                      children: [
                        _Identifier('    _scaleController', .variable),
                        _Identifier('.', .other),
                        _Identifier('dispose', .callable),
                        _Identifier('();', .other),
                      ],
                    ),
                    Row(
                      children: [
                        _Identifier('    super', .keyword),
                        _Identifier('.', .other),
                        _Identifier('dispose', .callable),
                        _Identifier('();', .other),
                      ],
                    ),
                    _Identifier('  }', .other),
                    _Identifier('', .other),
                  ],
                ),
              ],
            ),
            const Column(
              crossAxisAlignment: .start,
              children: [
                // build
                _Identifier('  @override', .annotation),
                Row(
                  children: [
                    _Identifier('  Widget', .type),
                    _Identifier(' ', .other),
                    _Identifier('build', .callable),
                    _Identifier('(', .other),
                    _Identifier('BuildContext', .type),
                    _Identifier(' ', .other),
                    _Identifier('context', .variable),
                    _Identifier(') {', .other),
                  ],
                ),
              ],
            ),
          ],
        ),
        // build body
        Stack(
          children: [
            const _Identifier('    return ', .keyword),
            CodeColumnTransition(
              anim: controller,
              config: [
                .opacity(tween: (1, 0), interval: exampleStateCodeBuildReturnInheritedStateOpacityFadeInterval),
                .height(tween: (1, 0), interval: exampleStateCodeBuildReturnInheritedStateHeightCollapseInterval),
              ],
              children: const [
                Row(
                  children: [
                    _Identifier('           ', .keyword),
                    _Identifier('_InheritedState', .callable),
                    _Identifier('(', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('      colorStream', .variable),
                    _Identifier(': ', .other),
                    _Identifier('_colorStream', .instanceVariable),
                    _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('      scaleController', .variable),
                    _Identifier(': ', .other),
                    _Identifier('_scaleController', .instanceVariable),
                    _Identifier(',', .other),
                  ],
                ),
                Row(children: [_Identifier('      child', .variable), _Identifier(':', .other)]),
                _Identifier('    );', .other),
              ],
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                CodeColumnTransition(
                  anim: controller,
                  config: [
                    .opacity(tween: (1, 0), interval: exampleStateCodeBuildReturnAnimatedLogoOpacityFadeInterval),
                    .height(tween: (1, 0), interval: exampleStateCodeBuildReturnAnimatedLogoHeightCollapseInterval),
                  ],
                  children: const [_Identifier('', .other), _Identifier('', .other), _Identifier('', .other)],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: exampleStateCodeBuildReturnAnimatedLogoIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('             ', .other),
                      child: const _Identifier('           ', .other),
                    ),
                    const _Identifier('const ', .keyword),
                    const _Identifier('_AnimatedFlutterLogo', .callable),
                    const _Identifier('()', .other),
                    ReplaceTransition(
                      animation: controller,
                      interval: exampleStateCodeBuildReturnAnimatedLogoCommaReplaceTransitionInterval,
                      prevChild: const _Identifier(',', .other),
                      child: const _Identifier(';', .other),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const _Identifier('  }', .other),
        const _Identifier('}', .other),
        const _Identifier('', .other),
        //
        // ***************************************************
        //
        // AnimatedFlutterLogo
        //
        // ***************************************************
        //
        // class _AnimatedFlutterLogo extends StatelessWidget {
        const Row(
          children: [
            _Identifier('class', .keyword),
            _Identifier(' ', .other),
            _Identifier('_AnimatedFlutterLogo', .type),
            _Identifier(' ', .other),
            _Identifier('extends', .keyword),
            _Identifier(' ', .other),
            _Identifier('StatelessWidget', .type),
            _Identifier(' ', .other),
            _Identifier('{', .other),
          ],
        ),
        // const _AnimatedFlutterLogo();
        const Row(
          children: [
            _Identifier('  const', .keyword),
            _Identifier(' ', .other),
            _Identifier('_AnimatedFlutterLogo', .type),
            _Identifier('();', .other),
          ],
        ),
        const _Identifier('', .other),
        // @override
        const _Identifier('  @override', .annotation),
        // Widget build(BuildContext context) {
        const Row(
          children: [
            _Identifier('  Widget', .type),
            _Identifier(' ', .other),
            _Identifier('build', .callable),
            _Identifier('(', .other),
            _Identifier('BuildContext', .type),
            _Identifier(' ', .other),
            _Identifier('context', .variable),
            _Identifier(') {', .other),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const _Identifier('    return ', .keyword),
            // old, removed code
            CodeColumnTransition(
              anim: controller,
              config: [
                .opacity(tween: (1, 0), interval: logoOldCodeOpacityFadeInterval),
                .height(tween: (1, 0), interval: logoOldCodeHeightCollapseInterval),
              ],
              children: const [
                Row(
                  children: [
                    _Identifier('           ', .other),
                    _Identifier('StreamBuilder', .callable),
                    _Identifier('(', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('      stream', .variable),
                    _Identifier(': ', .other),
                    _Identifier('_InheritedState', .type),
                    _Identifier('.', .other),
                    _Identifier('of', .callable),
                    _Identifier('(', .other),
                    _Identifier('context', .variable),
                    _Identifier(')', .other),
                    _Identifier('.', .other),
                    _Identifier('colorStream', .instanceVariable),
                    _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('      builder', .variable),
                    _Identifier(': (', .other),
                    _Identifier('context', .instanceVariable),
                    _Identifier(', ', .other),
                    _Identifier('colorSnapshot', .instanceVariable),
                    _Identifier(') => ', .other),
                    _Identifier('ValueListenableBuilder', .callable),
                    _Identifier('(', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('        valueListenable', .variable),
                    _Identifier(': ', .other),
                    _Identifier('_InheritedState', .type),
                    _Identifier('.', .other),
                    _Identifier('of', .callable),
                    _Identifier('(', .other),
                    _Identifier('context', .variable),
                    _Identifier(')', .other),
                    _Identifier('.', .other),
                    _Identifier('scaleController', .variable),
                    _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    _Identifier('        builder', .variable),
                    _Identifier(': (', .other),
                    _Identifier('context', .variable),
                    _Identifier(', ', .other),
                    _Identifier('scale', .variable),
                    _Identifier(', ', .other),
                    _Identifier('_', .variable),
                    _Identifier(') => ', .other),
                  ],
                ),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('', .other),
                _Identifier('      ),', .other),
                _Identifier('    );', .other),
              ],
            ),
            // context_plus code
            Column(
              crossAxisAlignment: .start,
              children: [
                CodeColumnTransition(
                  anim: controller,
                  config: [
                    .height(tween: (1, 0), interval: logoOldCodeColumnHeightCollapseInterval),
                    .opacity(tween: (1, 0), interval: logoOldCodeColumnOpacityCollapseInterval),
                  ],
                  children: const [
                    _Identifier('', .other),
                    _Identifier('', .other),
                    _Identifier('', .other),
                    _Identifier('', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeTransformIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('                                        ', .other),
                      child: const _Identifier('           ', .other),
                    ),
                    const _Identifier('Transform', .callable),
                    const _Identifier('.', .other),
                    const _Identifier('scale', .callable),
                    const _Identifier('(', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeScaleIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('          ', .other),
                      child: const _Identifier('      ', .other),
                    ),
                    const _Identifier('scale', .variable),
                    const _Identifier(': ', .other),
                    ReplaceTransition(
                      animation: controller,
                      interval: logoScaleVariableTransitionInterval,
                      prevChild: const Row(children: [_Identifier('scale', .variable), _Identifier(',', .other)]),
                      child: const Row(
                        children: [
                          _Identifier('_scaleController', .variable),
                          _Identifier('.', .other),
                          _Identifier('watch', .callable),
                          _Identifier('(', .other),
                          _Identifier('context', .variable),
                          _Identifier(')', .other),
                          _Identifier(',', .other),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeChildIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('          ', .other),
                      child: const _Identifier('      ', .other),
                    ),
                    const _Identifier('child', .variable),
                    const _Identifier(': ', .other),
                    const _Identifier('FlutterLogo', .callable),
                    const _Identifier('(', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeSizeIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('            ', .other),
                      child: const _Identifier('        ', .other),
                    ),
                    const _Identifier('size', .variable),
                    const _Identifier(': ', .other),
                    const _Identifier('200', .number),
                    const _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeStyleIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('            ', .other),
                      child: const _Identifier('        ', .other),
                    ),
                    const _Identifier('style', .variable),
                    const _Identifier(': ', .other),
                    const _Identifier('FlutterLogoStyle', .type),
                    const _Identifier('.', .other),
                    const _Identifier('stacked', .enumItem),
                    const _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeTextColorIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('            ', .other),
                      child: const _Identifier('        ', .other),
                    ),
                    const _Identifier('textColor', .variable),
                    const _Identifier(': ', .other),
                    ReplaceTransition(
                      animation: controller,
                      interval: logoColorStreamTransitionInterval,
                      prevChild: const _Identifier('colorSnapshot', .variable),
                      child: const Row(
                        children: [
                          _Identifier('_colorStream', .variable),
                          _Identifier('.', .other),
                          _Identifier('watch', .callable),
                          _Identifier('(', .other),
                          _Identifier('context', .variable),
                          _Identifier(')', .other),
                        ],
                      ),
                    ),
                    const _Identifier('.', .other),
                    const _Identifier('data', .instanceVariable),
                    const _Identifier(' ?? ', .other),
                    const _Identifier('Colors', .type),
                    const _Identifier('.', .other),
                    const _Identifier('transparent', .enumItem),
                    const _Identifier(',', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeClosingParenIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('          ', .other),
                      child: const _Identifier('      ', .other),
                    ),
                    const _Identifier('),', .other),
                  ],
                ),
                Row(
                  children: [
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeClosingParenSecondIndentReplaceTransitionInterval,
                      prevChild: const _Identifier('        ', .other),
                      child: const _Identifier('    ', .other),
                    ),
                    const _Identifier(')', .other),
                    ReplaceTransition(
                      animation: controller,
                      interval: logoOldCodeClosingParenCommaReplaceTransitionInterval,
                      prevChild: const _Identifier(',', .other),
                      child: const _Identifier(';', .other),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const _Identifier('  }', .other),
        const _Identifier('}', .other),
      ],
    );

    return RepaintBoundary(child: code);
  }
}

enum _IdentifierType { keyword, type, variable, callable, instanceVariable, annotation, number, enumItem, other }

class _Identifier extends StatelessWidget {
  const _Identifier(this.text, this.type);

  final String text;
  final _IdentifierType type;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Text(
        text,
        style: switch (type) {
          .keyword => const TextStyle(color: Colors.red),
          .type => const TextStyle(color: Colors.lightBlueAccent),
          .variable => const TextStyle(color: Colors.orange, fontWeight: FontWeight.w700),
          .callable => const TextStyle(color: Colors.lightGreen),
          .instanceVariable => const TextStyle(color: Colors.orange),
          .annotation => const TextStyle(color: Colors.yellowAccent),
          .number => const TextStyle(color: Colors.purpleAccent),
          .enumItem => const TextStyle(color: Colors.blue),
          .other => const TextStyle(color: Colors.white),
        },
      ),
    );
  }
}
