import 'dart:math' as math;

import 'package:context_plus/context_plus.dart';
import 'package:example/home/showcase/src/code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../widgets/animated_arrow_down.dart';
import '../widgets/code_quote.dart';
import '../widgets/gradient_glow_decoration.dart';
import 'src/background_gradient.dart';
import 'src/code_showcase_animation_step.dart';

final _codeAnimCtrl = Ref<CodeAnimationController>();
final _mobileExpandShowcaseStepDescriptionCtrl = Ref<AnimationController?>();
final _showcaseLayout = Ref<_ShowcaseLayout>();

enum _ShowcaseLayout { desktop, smallerDesktop, mobile }

class CodeShowcase extends StatelessWidget {
  const CodeShowcase({super.key, required this.homeScrollController, required this.codeAnimationController});

  final ScrollController homeScrollController;
  final CodeAnimationController codeAnimationController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    _codeAnimCtrl.bindValue(context, codeAnimationController);
    _showcaseLayout.bindValue(
      context,
      width >= 1280
          ? _ShowcaseLayout.desktop
          : width >= 890
          ? _ShowcaseLayout.smallerDesktop
          : _ShowcaseLayout.mobile,
    );
    _mobileExpandShowcaseStepDescriptionCtrl.bind(context, key: _showcaseLayout.of(context), (vsync) {
      if (_showcaseLayout.of(context) != _ShowcaseLayout.mobile) {
        return null;
      }
      return AnimationController(vsync: vsync, duration: const Duration(milliseconds: 300));
    });

    return switch (_showcaseLayout.of(context)) {
      _ShowcaseLayout.desktop || _ShowcaseLayout.smallerDesktop => const _DesktopView(),
      _ShowcaseLayout.mobile => const _MobileView(),
    };
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
        const Positioned(left: 0, right: 0, bottom: 0, height: 128, child: IgnorePointer(child: BackgroundGradient())),
        const Positioned(left: 0, right: 0, bottom: 32, child: IgnorePointer(child: _ShortPackageDescription())),
        const Positioned(left: 0, right: 0, bottom: 4, child: IgnorePointer(child: _ScrollDownArrow())),
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
        Positioned(left: 12, right: 12, top: 110, bottom: 120, child: _CodeAnimation()),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 128,
          child: BackgroundGradient(direction: BackgroundGradientDirection.top),
        ),
        Positioned(left: 0, right: 0, top: 16, child: _ShortPackageDescription()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_MobileCodeAnimationStepDescription(), _MobileCodeAnimationStepButtons()],
          ),
        ),
        Positioned(right: 24, bottom: 24, child: _ScrollDownArrow()),
      ],
    );
  }
}

class _CodeAnimation extends StatelessWidget {
  const _CodeAnimation();

  @override
  Widget build(BuildContext context) {
    final codeAnimCtrl = _codeAnimCtrl.of(context);
    final code = Padding(
      padding: const .all(16),
      child: Code(controller: codeAnimCtrl),
    );

    const gradientDuration = Duration(seconds: 5);
    final gradientAnim = context.use(
      () => AnimationController(vsync: context.vsync, duration: gradientDuration)..repeat(),
      key: gradientDuration,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Builder(
        builder: (context) => DecoratedBox(
          decoration: GradientGlowDecoration(
            backgroundColor: Colors.black,
            colors: const [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ],
            borderOpacity: 0.25,
            opacity: 0.25 + codeAnimCtrl.watch(context) * 0.25,
            blurRadius: 64,
            rotation: gradientAnim.watch(context) * math.pi * 2,
            borderRadius: const .all(.circular(16)),
          ),
          child: code,
        ),
      ),
    );
  }
}

class _DesktopCodeAnimationStepButtons extends StatelessWidget {
  const _DesktopCodeAnimationStepButtons();

  static const width = 332.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var step = 0; step < Code.steps; step++)
            CodeShowcaseProgressStep(
              codeAnimCtrl: _codeAnimCtrl.of(context),
              expandCtrl: null,
              isMobileLayout: false,
              step: step,
            ),
        ],
      ),
    );
  }
}

class _MobileCodeAnimationStepButtons extends StatelessWidget {
  const _MobileCodeAnimationStepButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var step = 0; step < Code.steps; step++) ...[
            _MobileCodeAnimationStepButton(step: step),
            if (step < Code.steps - 1) const Gap(8),
          ],
        ],
      ),
    );
  }
}

class _MobileCodeAnimationStepButton extends StatelessWidget {
  const _MobileCodeAnimationStepButton({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final ctrl = _codeAnimCtrl.of(context);
    final progress = ctrl.watchOnly(context, (_) => ctrl.stepProgress(step));
    final borderColor = ColorTween(begin: const Color(0x22FFFFFF), end: const Color(0x80FFFFFF)).transform(progress)!;

    return SizedBox.square(
      dimension: 48,
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        color: const Color(0xB0000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _codeAnimCtrl.of(context).animateToStep(step),
          child: Center(
            child: SvgPicture.asset(
              switch (step) {
                0 => 'assets/svg/emoji_u1f44b.svg', // 👋
                1 => 'assets/svg/emoji_u1f517.svg', // 🔗
                2 => 'assets/svg/emoji_u1f91d.svg', // 🤝
                3 => 'assets/svg/emoji_u1f440.svg', // 👀
                _ => throw UnsupportedError('Unsupported page: $step'),
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
    final codeAnimCtrl = _codeAnimCtrl.of(context)..watch(context);
    final expandCtrl = _mobileExpandShowcaseStepDescriptionCtrl.of(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        for (var step = 0; step < Code.steps; step++)
          CodeShowcaseProgressStep(
            key: ValueKey(step),
            codeAnimCtrl: codeAnimCtrl,
            expandCtrl: expandCtrl,
            step: step,
            isMobileLayout: true,
          ),
      ],
    );
  }
}

class _ShortPackageDescription extends StatelessWidget {
  const _ShortPackageDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    CodeQuote(child: CodeType(type: 'BuildContext')),
                    Text(', conveniently.'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScrollDownArrow extends StatelessWidget {
  const _ScrollDownArrow();

  @override
  Widget build(BuildContext context) {
    final ctrl = _codeAnimCtrl.of(context);
    final isShowcaseCompleted = ctrl.watchOnly(context, (_) => ctrl.reachedLastStep);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      opacity: isShowcaseCompleted ? 0 : 1,
      child: const AnimatedArrowDown(),
    );
  }
}
