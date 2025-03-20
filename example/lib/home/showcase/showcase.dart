import 'package:context_plus/context_plus.dart';
import 'package:example/other/double_precision_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;

import '../../other/svg_icon.dart';
import '../widgets/animated_arrow_down.dart';
import '../widgets/code_quote.dart';
import '../widgets/typewriter_text.dart';
import 'src/background_gradient.dart';
import 'src/code_showcase_animation_step.dart';
import 'src/halo_box.dart';
import 'src/showcase_rive_animation.dart';

final _isShowcaseCompleted = Ref<ValueNotifier<bool>>();
final _showcaseCtrl = Ref<ShowcaseRiveController>();

final _appearCtrl = Ref<AnimationController>();

final _isIntroCompleted = Ref<ValueNotifier<bool>>();
final _introCtrl = Ref<AnimationController>();
const _introDuration = Duration(seconds: 6);

final _mobileExpandShowcaseStepDescriptionCtrl = Ref<AnimationController?>();

final _showcaseLayout = Ref<_ShowcaseLayout>();

final _homeScrollController = Ref<ScrollController>();
final _hasScrolled = Ref<ValueNotifier<bool>>();

enum _ShowcaseLayout { desktop, smallerDesktop, mobile }

class Showcase extends StatelessWidget {
  const Showcase({
    super.key,
    required this.onCompleted,
    required this.homeScrollController,
  });

  final VoidCallback onCompleted;
  final ScrollController homeScrollController;

  @override
  Widget build(BuildContext context) {
    final hasScrolled =
        _hasScrolled.bind(context, (context) => ValueNotifier(false));
    _homeScrollController
        .bindValue(context, homeScrollController)
        .watchEffect(context, (ctrl) {
      if (ctrl.offset > 120) hasScrolled.value = true;
    });

    final isShowcaseCompleted =
        _isShowcaseCompleted.bind(context, (context) => ValueNotifier(false));

    final showcaseCtrl =
        _showcaseCtrl.bind(context, (context) => ShowcaseRiveController())
          ..watchEffect(context, (ctrl) {
            if (ctrl.currentKeyframe.isFinal && !isShowcaseCompleted.value) {
              isShowcaseCompleted.value = true;
              onCompleted();
            }
          });

    final appearCtrl = _appearCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 1),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            showcaseCtrl.animateToKeyframe(ShowcaseKeyframe.values.last);
          }
        }),
    );
    final isIntroCompleted =
        _isIntroCompleted.bind(context, (context) => ValueNotifier(false));
    _introCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: _introDuration,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            isIntroCompleted.value = true;
            appearCtrl.forward();
          }
        }),
    );

    final width = MediaQuery.of(context).size.width;
    final layout = _showcaseLayout.bindValue(
      context,
      width >= 1280
          ? _ShowcaseLayout.desktop
          : width >= 890
              ? _ShowcaseLayout.smallerDesktop
              : _ShowcaseLayout.mobile,
    );

    _mobileExpandShowcaseStepDescriptionCtrl.bind(context, (vsync) {
      if (layout != _ShowcaseLayout.mobile) {
        return null;
      }
      return AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 300),
      );
    }, key: layout);

    return CustomPaint(
      isComplex: true,
      willChange: false,
      painter: const _BlueprintPainter(),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            const Center(
              child: _IntroText(),
            ),
            RepaintBoundary(
              child: switch (layout) {
                _ShowcaseLayout.desktop ||
                _ShowcaseLayout.smallerDesktop =>
                  const _DesktopView(),
                _ShowcaseLayout.mobile => const _MobileView(),
              },
            ),
            const Positioned(
              right: 16,
              bottom: 12,
              child: _SkipIntroButton(),
            ),
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
    if (progress == 0 || progress == 1) {
      return const SizedBox.shrink();
    }

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TypewriterText(
            progress: progress,
            intervals: const [
              (0.1, 0.5),
              (0.6, 0.8),
            ],
            rows: const [
              'Value propagation in Flutter can get bulky sometimes...',
              '\nCan we make it easier?',
            ],
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: 'Fira Code'),
          ),
        ),
      ),
    );
  }
}

class _SkipIntroButton extends StatelessWidget {
  const _SkipIntroButton();

  @override
  Widget build(BuildContext context) {
    final introCtrl = _introCtrl.of(context);
    final showcaseCtrl = _showcaseCtrl.of(context);
    final isShowcaseCompleted = _isShowcaseCompleted.watch(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isShowcaseCompleted ? 0 : 1,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: OutlinedButton(
          onPressed: () {
            introCtrl.duration = _introDuration ~/ 10;
            introCtrl.forward();
            showcaseCtrl.animateToKeyframe(
              ShowcaseKeyframe.values.last,
              jump: true,
            );
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: const SizedBox(
            height: 36,
            child: Row(
              children: [
                Gap(18),
                Text('Skip intro'),
                Gap(8),
                SvgIcon(
                  'assets/svg/icon_skip_next_circle.svg',
                  width: 24,
                  height: 24,
                ),
                Gap(6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  const _DesktopView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 24,
          bottom: 88,
          left: 24,
          right: 24,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_showcaseLayout.of(context) == _ShowcaseLayout.desktop) ...[
                const Gap(_DesktopCodeAnimationStepButtons.width),
                const Gap(12),
              ],
              const Flexible(child: _CodeAnimation()),
              const Gap(12),
              const _DesktopCodeAnimationStepButtons(),
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 128,
          child: IgnorePointer(
            child: BackgroundGradient(),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: IgnorePointer(
            child: _ShortPackageDescription(),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 4,
          child: IgnorePointer(
            child: _ScrollDownArrow(),
          ),
        ),
      ],
    );
  }
}

class _MobileView extends StatelessWidget {
  const _MobileView();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 12,
          right: 12,
          top: 110,
          bottom: 120,
          child: _CodeAnimation(),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 128,
          child: BackgroundGradient(
            direction: BackgroundGradientDirection.top,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 16,
          child: _ShortPackageDescription(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MobileCodeAnimationStepDescription(),
              _MobileCodeAnimationStepButtons(),
            ],
          ),
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: _ScrollDownArrow(),
        ),
      ],
    );
  }
}

class _CodeAnimation extends StatelessWidget {
  const _CodeAnimation();

  static final _codeAnimationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ctrl = _showcaseCtrl.of(context)..watch(context);

    // Rive doesn't support artboard size animations yet, so we need to
    // cut the window out of the animation ourselves.
    //
    // Additional 4 pixels are added to prevent the window from being cut off
    // due to inaccuracies in the estimated height calculation.
    const inaccuracyCompensation = 4;
    const constraints = BoxConstraints(
      minWidth: ShowcaseRiveController.windowWidth + inaccuracyCompensation,
      minHeight:
          ShowcaseRiveController.initialWindowHeight + inaccuracyCompensation,
      maxWidth: ShowcaseRiveController.windowWidth * 1.5,
      maxHeight: ShowcaseRiveController.initialWindowHeight * 1.5,
    );

    final estimatedWindowHeight = ctrl.estimatedWindowHeight + 4;
    final animationProgress = ctrl.animationProgress;

    final windowAspectRatio =
        ShowcaseRiveController.windowWidth / estimatedWindowHeight;
    final windowSize =
        Size(ShowcaseRiveController.windowWidth, estimatedWindowHeight);

    return _AppearAnimation(
      beginAt: 0,
      endAt: 0.75,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ConstrainedBox(
          constraints: constraints,
          child: AspectRatio(
            aspectRatio: windowAspectRatio,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  HaloBox(
                    size: windowSize,
                    opacity: animationProgress,
                  ),
                  SizedBox.fromSize(
                    size: windowSize,
                    child: SizedOverflowBox(
                      size: windowSize,
                      child: UnconstrainedBox(
                        clipBehavior: Clip.hardEdge,
                        child: RiveAnimation.asset(
                          key: _codeAnimationKey,
                          'assets/showcase/context_plus_showcase_v12.riv',
                          controllers: [ctrl],
                          useArtboardSize: true,
                          onInit: (artboard) =>
                              _introCtrl.of(context).forward(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopCodeAnimationStepButtons extends StatelessWidget {
  const _DesktopCodeAnimationStepButtons();

  static const width = 330.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: _AppearAnimation(
        beginAt: 0.25,
        endAt: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final keyframe in ShowcaseKeyframe.values)
              _DesktopCodeAnimationStepButton(keyframe: keyframe),
          ],
        ),
      ),
    );
  }
}

class _DesktopCodeAnimationStepButton extends StatelessWidget {
  const _DesktopCodeAnimationStepButton({
    required this.keyframe,
  });

  final ShowcaseKeyframe keyframe;

  @override
  Widget build(BuildContext context) {
    final progress =
        _watchKeyframeTransitionProgress(context: context, keyframe: keyframe);
    final opacity = (1 / 3 + 2 / 3 * progress).clamp(0.0, 1.0).toPrecision(2);

    return CodeShowcaseProgressStep(
      showcaseCtrl: _showcaseCtrl.of(context),
      expandCtrl: null,
      isMobileLayout: false,
      keyframe: keyframe,
      opacity: opacity,
      descriptionVisibilityFactor: progress,
    );
  }
}

class _MobileCodeAnimationStepButtons extends StatelessWidget {
  const _MobileCodeAnimationStepButtons();

  @override
  Widget build(BuildContext context) {
    return _AppearAnimation(
      beginAt: 0.25,
      endAt: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < ShowcaseKeyframe.values.length; i++) ...[
              _MobileCodeAnimationStepButton(
                keyframe: ShowcaseKeyframe.values[i],
              ),
              if (i < ShowcaseKeyframe.values.length - 1) const Gap(8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MobileCodeAnimationStepButton extends StatelessWidget {
  const _MobileCodeAnimationStepButton({
    required this.keyframe,
  });

  final ShowcaseKeyframe keyframe;

  @override
  Widget build(BuildContext context) {
    final progress =
        _watchKeyframeTransitionProgress(context: context, keyframe: keyframe);

    final borderColor = ColorTween(
      begin: const Color(0x22FFFFFF),
      end: const Color(0x80FFFFFF),
    ).transform(progress)!;

    return SizedBox.square(
      dimension: 48,
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        color: const Color(0xB0000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _showcaseCtrl.of(context).animateToKeyframe(keyframe),
          child: Center(
            child: SvgPicture.asset(
              switch (keyframe) {
                ShowcaseKeyframe.vanillaFlutter =>
                  'assets/svg/emoji_u1f44b.svg', // 👋
                ShowcaseKeyframe.ref => 'assets/svg/emoji_u1f517.svg', // 🔗
                ShowcaseKeyframe.bind => 'assets/svg/emoji_u1f91d.svg', // 🤝
                ShowcaseKeyframe.watch => 'assets/svg/emoji_u1f440.svg', // 👀
              },
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileCodeAnimationStepDescription extends StatelessWidget {
  const _MobileCodeAnimationStepDescription();

  @override
  Widget build(BuildContext context) {
    final isIntroCompleted = _isIntroCompleted.watch(context);
    if (!isIntroCompleted) {
      return const SizedBox.shrink();
    }

    final showcaseCtrl = _showcaseCtrl.of(context)..watch(context);
    final expandCtrl = _mobileExpandShowcaseStepDescriptionCtrl.of(context);

    final currentKeyframe = showcaseCtrl.currentKeyframe;
    final currentKeyframeTransitionProgress = _watchKeyframeTransitionProgress(
      context: context,
      keyframe: currentKeyframe,
    );

    double? nextKeyframeTransitionProgress;
    final nextKeyframe = showcaseCtrl.nextKeyframe;
    if (nextKeyframe != null) {
      nextKeyframeTransitionProgress = _watchKeyframeTransitionProgress(
        context: context,
        keyframe: nextKeyframe,
      );
    }

    return _AppearAnimation(
      beginAt: 0.5,
      endAt: 1,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          CodeShowcaseProgressStep(
            key: ValueKey(currentKeyframe),
            showcaseCtrl: showcaseCtrl,
            expandCtrl: expandCtrl,
            keyframe: currentKeyframe,
            isMobileLayout: true,
            descriptionVisibilityFactor: 0,
            opacity: currentKeyframeTransitionProgress,
            translateY: -16 * (1 - currentKeyframeTransitionProgress),
          ),
          if (nextKeyframe != null &&
              nextKeyframeTransitionProgress != null &&
              nextKeyframeTransitionProgress > 0)
            CodeShowcaseProgressStep(
              key: ValueKey(nextKeyframe),
              showcaseCtrl: showcaseCtrl,
              expandCtrl: expandCtrl,
              keyframe: nextKeyframe,
              isMobileLayout: true,
              descriptionVisibilityFactor: 0,
              opacity: nextKeyframeTransitionProgress,
              translateY: 16 * (1 - nextKeyframeTransitionProgress),
            ),
        ],
      ),
    );
  }
}

class _ShortPackageDescription extends StatelessWidget {
  const _ShortPackageDescription();

  @override
  Widget build(BuildContext context) {
    return _AppearAnimation(
      beginAt: 0.75,
      endAt: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTextStyle.merge(
              style: Theme.of(context).textTheme.titleLarge!,
              child: const Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text('Bind and observe values for a '),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CodeQuote(
                        child: CodeType(type: 'BuildContext'),
                      ),
                      Text(', conveniently.'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollDownArrow extends StatelessWidget {
  const _ScrollDownArrow();

  @override
  Widget build(BuildContext context) {
    final isShowcaseCompleted = _isShowcaseCompleted.watch(context);
    final hasScrolled = _hasScrolled.watch(context);
    final height = MediaQuery.sizeOf(context).height;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      opacity: isShowcaseCompleted && !hasScrolled ? 1 : 0,
      child: GestureDetector(
        onTap: () => _homeScrollController.of(context).animateTo(
              height,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            ),
        child: const AnimatedArrowDown(),
      ),
    );
  }
}

// region Utils

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
    final opacity = curve
        .transform(_appearCtrl.watch(context))
        .clamp(0.0, 1.0)
        .toPrecision(2);
    final translateY = (curve.transform(1 - opacity) * 16);
    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}

class _BlueprintPainter extends CustomPainter {
  const _BlueprintPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x03FFFFFF)
      ..strokeWidth = 1;

    const step = 16.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    paint.color = const Color(0x04FFFFFF);
    for (var x = 0.0; x < size.width; x += step * 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step * 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double _watchKeyframeTransitionProgress({
  required BuildContext context,
  required ShowcaseKeyframe keyframe,
}) {
  final ctrl = _showcaseCtrl.of(context)..watch(context);

  final currentKeyframe = ctrl.currentKeyframe;
  final nextKeyframe = ctrl.nextKeyframe;

  if (nextKeyframe == null) {
    return switch (keyframe) {
      _ when keyframe == currentKeyframe => 1,
      _ => 0,
    };
  }

  final rawKeyframeTransitionProgress =
      (ctrl.frame - currentKeyframe.frame).abs() /
          (nextKeyframe.frame - currentKeyframe.frame).abs();

  final keyframeTransitionProgress = const ElasticInOutCurve(1).transform(
    rawKeyframeTransitionProgress.clamp(0.0, 1.0),
  );

  final progress = switch (keyframe) {
    _ when keyframe == currentKeyframe => 1 - keyframeTransitionProgress,
    _ when keyframe == nextKeyframe => keyframeTransitionProgress,
    _ => 0.0,
  }
      .clamp(0.0, 1.0);

  return progress.toPrecision(2);
}

// endregion
