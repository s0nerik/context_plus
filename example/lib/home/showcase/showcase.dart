import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';

import '../widgets/animated_arrow_down.dart';
import '../widgets/code_quote.dart';
import '../widgets/typewriter_text.dart';
import 'showcase_rive_animation.dart';

final _isShowcaseCompleted = Ref<ValueNotifier<bool>>();
final _showcaseCtrl = Ref<ShowcaseRiveController>();

final _appearCtrl = Ref<AnimationController>();
const _appearDuration = Duration(seconds: 1);

final _introCtrl = Ref<AnimationController>();
const _introDuration = Duration(seconds: 10);

class Showcase extends StatelessWidget {
  const Showcase({super.key});

  static final _link = Ref<LayerLink>();

  @override
  Widget build(BuildContext context) {
    final isShowcaseCompleted =
        _isShowcaseCompleted.bind(context, () => ValueNotifier(false));
    final showcaseCtrl = _showcaseCtrl.bind(context, () {
      final ctrl = ShowcaseRiveController();
      return ctrl
        ..currentKeyframe.addListener(() {
          if (ctrl.currentKeyframe.value.isFinal) {
            isShowcaseCompleted.value = true;
          }
        });
    });
    final appearCtrl = _appearCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: _appearDuration,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            showcaseCtrl.animateToKeyframe(ShowcaseKeyframe.values.last);
          }
        }),
    );
    _introCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: _introDuration,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            appearCtrl.forward();
          }
        }),
    );
    final layerLink = _link.bind(context, LayerLink.new);
    return Stack(
      children: [
        const Center(
          child: _IntroText(),
        ),
        Center(
          child: CompositedTransformTarget(
            link: layerLink,
            child: const _CodeAnimation(),
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(16, 0),
          child: const _CodeAnimationProgress(),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _ShortPackageDescription(),
        ),
        const Positioned(
          right: 16,
          bottom: 16,
          child: _SkipIntroButton(),
        ),
      ],
    );
  }
}

class _SkipIntroButton extends StatelessWidget {
  const _SkipIntroButton();

  @override
  Widget build(BuildContext context) {
    final introCtrl = _introCtrl.of(context);
    final showcaseCtrl = _showcaseCtrl.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isShowcaseCompleted.watch(context) ? 0 : 1,
      child: OutlinedButton(
        onPressed: () {
          introCtrl.duration = _introDuration ~/ 10;
          introCtrl.forward();
          showcaseCtrl.animateToKeyframe(
            ShowcaseKeyframe.values.last,
            jump: true,
          );
        },
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: const Row(
          children: [
            Gap(16),
            Text('Skip intro'),
            Gap(8),
            Icon(MdiIcons.skipNextCircle),
            Gap(4),
          ],
        ),
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    final progress = _introCtrl.watch(context);

    const curve = Curves.easeOutCubic;
    const hideAt = 0.95;
    const hideIntervalDuration = 1 - hideAt;
    final opacity = progress > hideAt
        ? curve
            .transform(1 - (progress - hideAt) / hideIntervalDuration)
            .clamp(0.0, 1.0)
        : 1.0;
    final translateY = curve.transform(1 - opacity) * -120;

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(
        opacity: opacity,
        child: TypewriterText(
          progress: progress,
          intervals: const [
            (0.0, 0.3),
            (0.4, 0.65),
            (0.75, 0.85),
          ],
          rows: const [
            'Value propagation in Flutter can get bulky sometimes...',
            'What if there was a way to make it more convenient?',
            'Meet context_plus!',
          ],
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: 'Fira Code'),
        ),
      ),
    );
  }
}

class _CodeAnimation extends StatelessWidget {
  const _CodeAnimation();

  @override
  Widget build(BuildContext context) {
    final ctrl = _showcaseCtrl.of(context);
    return _AppearAnimation(
      beginAt: 0,
      endAt: 0.75,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: ctrl.optimalWidth.watch(context),
            height: ctrl.optimalHeight,
            child: RiveAnimation.asset(
              'assets/showcase/context_plus_showcase_v8.riv',
              controllers: [ctrl],
              fit: BoxFit.fitWidth,
              onInit: (artboard) => _introCtrl.of(context).forward(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeAnimationProgress extends StatelessWidget {
  const _CodeAnimationProgress();

  @override
  Widget build(BuildContext context) {
    return _AppearAnimation(
      beginAt: 0.25,
      endAt: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final keyframe in ShowcaseKeyframe.values)
            _CodeShowcaseProgressStep(keyframe: keyframe),
        ],
      ),
    );
  }
}

class _CodeShowcaseProgressStep extends StatelessWidget {
  const _CodeShowcaseProgressStep({
    required this.keyframe,
  });

  final ShowcaseKeyframe keyframe;

  @override
  Widget build(BuildContext context) {
    final ctrl = _showcaseCtrl.of(context);

    final currentKeyframe = ctrl.currentKeyframe.watch(context);
    final nextKeyframe = ctrl.nextKeyframe.watch(context);
    final keyframeTransitionProgress = const ElasticInOutCurve(1).transform(
      ctrl.keyframeTransitionProgress.watch(context),
    );

    final progress = switch (keyframe) {
      _ when keyframe == nextKeyframe => keyframeTransitionProgress,
      _ when keyframe == currentKeyframe => 1 - keyframeTransitionProgress,
      _ => 0,
    };
    final opacity = (0.25 + 0.75 * progress).clamp(0.0, 1.0);
    final scale = 1 + 0.25 * progress;

    final titleStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white);

    final descriptionStyle =
        Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white60);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.centerLeft,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => ctrl.animateToKeyframe(keyframe),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(
              textAlign: TextAlign.start,
              style: titleStyle,
              TextSpan(
                children: switch (keyframe) {
                  ShowcaseKeyframe.vanillaFlutter => [
                      const TextSpan(
                        children: [
                          TextSpan(text: 'Hello, vanilla '),
                          TextSpan(text: 'Flutter'),
                          TextSpan(text: '!\n'),
                        ],
                      ),
                      TextSpan(
                        style: descriptionStyle,
                        text: 'Let me show you something cool!',
                      ),
                    ],
                  ShowcaseKeyframe.ref => [
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Bye, '),
                          WidgetSpan(
                            child: CodeQuote.type(
                              'InheritedWidget',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: '! Hello, '),
                          WidgetSpan(
                            child: CodeQuote.type(
                              'Ref',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ],
                  ShowcaseKeyframe.bind => [
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Bye, '),
                          WidgetSpan(
                            child: CodeQuote.type(
                              'StatefulWidget',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: '! Hello, '),
                          WidgetSpan(
                            child: CodeQuote.functionCall(
                              'bind',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ],
                  ShowcaseKeyframe.watch => [
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Bye, '),
                          WidgetSpan(
                            child: CodeQuote.type(
                              'Builder',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: 's! Hello, '),
                          WidgetSpan(
                            child: CodeQuote.functionCall(
                              'watch',
                              style: titleStyle,
                            ),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                    ],
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortPackageDescription extends StatelessWidget {
  const _ShortPackageDescription();

  @override
  Widget build(BuildContext context) {
    final codeCtrl = _showcaseCtrl.of(context);

    final currentKeyframe = codeCtrl.currentKeyframe.watch(context);
    final nextKeyframe = codeCtrl.nextKeyframe.watch(context);
    final keyframeTransitionProgress =
        codeCtrl.keyframeTransitionProgress.watch(context);

    const curve = ElasticInOutCurve(1);

    late final double opacity;
    late final double translateY;
    if (currentKeyframe.isFinal && nextKeyframe.isFinal) {
      opacity = 1;
      translateY = 0;
    } else if (currentKeyframe.isFinal) {
      opacity = curve.transform(1 - keyframeTransitionProgress).clamp(0.0, 1.0);
      translateY = 16 * curve.transform(keyframeTransitionProgress);
    } else if (nextKeyframe.isFinal) {
      opacity = curve.transform(keyframeTransitionProgress).clamp(0.0, 1.0);
      translateY = 16 * curve.transform(1 - keyframeTransitionProgress);
    } else {
      opacity = 0;
      translateY = 16;
    }

    // If opacity is close to 0, return an empty SizedBox to avoid
    // unnecessary rebuilds.
    if (opacity < 0.001) {
      return const SizedBox.shrink();
    }

    final textStyle = Theme.of(context).textTheme.titleLarge!;

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text.rich(
                textAlign: TextAlign.center,
                style: textStyle,
                TextSpan(
                  children: [
                    const TextSpan(text: 'Bind and observe values for a '),
                    WidgetSpan(
                      child: CodeQuote.type('BuildContext', style: textStyle),
                    ),
                    const TextSpan(text: ', conveniently.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const AnimatedArrowDown(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AppearAnimation extends StatelessWidget {
  const _AppearAnimation({
    required this.beginAt,
    required this.endAt,
    required this.child,
  });

  final double beginAt;
  final double endAt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curve = Interval(beginAt, endAt, curve: Curves.linearToEaseOut);
    final opacity = curve.transform(_appearCtrl.watch(context)).clamp(0.0, 1.0);
    final translateY = curve.transform(1 - opacity) * 16;
    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}
