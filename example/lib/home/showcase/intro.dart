import 'package:context_plus/context_plus.dart';
import 'package:example/home/widgets/typewriter_text.dart';
import 'package:example/other/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final _introCtrl = Ref<AnimationController>();
const _introDuration = Duration(seconds: 6);

class Intro extends StatelessWidget {
  const Intro({super.key, required this.onComplete, required this.onSkip});

  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    _introCtrl.bind(
      context,
      (vsync) => AnimationController(vsync: vsync, duration: _introDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            onComplete();
          }
        })
        ..animateTo(1),
      key: _introDuration,
    );

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        const Center(child: _IntroText()),
        Positioned(right: 16, bottom: 12, child: _SkipIntroButton(onSkip: onSkip)),
      ],
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
        ? curve.transform(1 - (progress - hideAt) / hideIntervalDuration).clamp(0.0, 1.0)
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
            intervals: const [(0.1, 0.5), (0.6, 0.8)],
            rows: const ['Value propagation in Flutter can get bulky sometimes...', '\nCan we make it easier?'],
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: 'Fira Code'),
          ),
        ),
      ),
    );
  }
}

class _SkipIntroButton extends StatelessWidget {
  const _SkipIntroButton({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final introCtrl = _introCtrl.of(context);

    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: () async {
          introCtrl.duration = _introDuration ~/ 10;
          await introCtrl.forward();
          onSkip();
        },
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: const SizedBox(
          height: 36,
          child: Row(
            children: [
              Gap(16),
              Text('Skip intro'),
              Gap(8),
              SvgIcon('assets/svg/icon_skip_next_circle.svg', width: 24, height: 24),
              Gap(6),
            ],
          ),
        ),
      ),
    );
  }
}
