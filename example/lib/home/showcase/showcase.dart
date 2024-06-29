import 'dart:math';

import 'package:context_plus/context_plus.dart';
import 'package:example/home/widgets/bullet_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../widgets/animated_arrow_down.dart';
import '../widgets/code_quote.dart';
import '../widgets/typewriter_text.dart';
import 'showcase_rive_animation.dart';

final _isShowcaseCompleted = Ref<ValueNotifier<bool>>();
final _showcaseCtrl = Ref<ShowcaseRiveController>();

final _appearCtrl = Ref<AnimationController>();
const _appearDuration = Duration(seconds: 1);

final _isIntroCompleted = Ref<ValueNotifier<bool>>();
final _introCtrl = Ref<AnimationController>();
const _introDuration = Duration(seconds: 10);

final _mobileExpandShowcaseStepDescriptionCtrl = Ref<AnimationController?>();
const _mobileShowcaseStepBackgroundColor = Color(0xDD000000);

final _codeAnimationKey = GlobalKey();

final _showcaseLayout = Ref<_ShowcaseLayout>();

enum _ShowcaseLayout { desktop, smallerDesktop, mobile }

class Showcase extends StatelessWidget {
  const Showcase({
    super.key,
    required this.onCompleted,
  });

  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final isShowcaseCompleted = _isShowcaseCompleted.bind(
      context,
      () {
        final notifier = ValueNotifier(false);
        return notifier
          ..addListener(() {
            if (notifier.value) {
              onCompleted();
            }
          });
      },
    );
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
    final isIntroCompleted = _isIntroCompleted.bind(
      context,
      () => ValueNotifier(false),
    );
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
      width >= 1220
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

    return Stack(
      fit: StackFit.expand,
      children: [
        const Center(
          child: _IntroText(),
        ),
        switch (layout) {
          _ShowcaseLayout.desktop => const _DesktopView(),
          _ShowcaseLayout.smallerDesktop => const _SmallerDesktopView(),
          _ShowcaseLayout.mobile => const _MobileView(),
        },
        const Positioned(
          right: 16,
          bottom: 16,
          child: _SkipIntroButton(),
        ),
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
      ),
    );
  }
}

class _SkipIntroButton extends StatelessWidget {
  const _SkipIntroButton();

  static final _showButton = Ref<ValueNotifier<bool>>();

  @override
  Widget build(BuildContext context) {
    final introCtrl = _introCtrl.of(context);
    final showcaseCtrl = _showcaseCtrl.of(context);
    final isShowcaseCompleted = _isShowcaseCompleted.watch(context);
    final showButton = _showButton.bind(
      context,
      () => ValueNotifier(!isShowcaseCompleted),
    );
    if (!showButton.watch(context)) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isShowcaseCompleted ? 0 : 1,
      onEnd: () => showButton.value = !isShowcaseCompleted,
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

class _DesktopView extends StatelessWidget {
  const _DesktopView();

  static final _link = Ref<LayerLink>();

  @override
  Widget build(BuildContext context) {
    final layerLink = _link.bind(context, LayerLink.new);
    return Stack(
      children: [
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
          offset: const Offset(0, 0),
          child: const _DesktopCodeAnimationStepButtons(),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 128,
          child: IgnorePointer(
            child: _Shadow(),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: _ShortPackageDescription(),
          ),
        ),
      ],
    );
  }
}

class _SmallerDesktopView extends StatelessWidget {
  const _SmallerDesktopView();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CodeAnimation(),
            _DesktopCodeAnimationStepButtons(),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 128,
          child: IgnorePointer(
            child: _Shadow(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: _ShortPackageDescription(),
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
    final currentKeyframe =
        _showcaseCtrl.of(context).currentKeyframe.watch(context);

    final codeVerticalPadding = switch (currentKeyframe) {
      ShowcaseKeyframe.vanillaFlutter => 64.0,
      ShowcaseKeyframe.ref => 36.0,
      ShowcaseKeyframe.bind => 0.0,
      ShowcaseKeyframe.watch => 0.0,
    };

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          top: codeVerticalPadding,
          bottom: codeVerticalPadding,
          child: const _CodeAnimation(),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 128,
          child: _Shadow(direction: _ShadowDirection.top),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 16,
          child: _ShortPackageDescription(),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MobileCodeAnimationStepDescription(),
              ColoredBox(
                color: Color(0xDD000000),
                child: _MobileCodeAnimationStepButtons(),
              ),
            ],
          ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: ctrl.optimalWidth.watch(context),
            height: ctrl.optimalHeight,
            child: RiveAnimation.asset(
              key: _codeAnimationKey,
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

class _DesktopCodeAnimationStepButtons extends StatelessWidget {
  const _DesktopCodeAnimationStepButtons();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 324,
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
    final opacity = (1 / 3 + 2 / 3 * progress).clamp(0.0, 1.0);

    return _CodeShowcaseProgressStep(
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
      child: Transform.scale(
        scale: 0.8,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final keyframe in ShowcaseKeyframe.values)
                _MobileCodeAnimationStepButton(keyframe: keyframe),
            ],
          ),
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

    return Card(
      elevation: 0,
      borderOnForeground: true,
      color: const Color(0xB0000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () => _showcaseCtrl.of(context).animateToKeyframe(keyframe),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            switch (keyframe) {
              ShowcaseKeyframe.vanillaFlutter => '👋',
              ShowcaseKeyframe.ref => '🔗',
              ShowcaseKeyframe.bind => '🤝',
              ShowcaseKeyframe.watch => '👀',
            },
            style: const TextStyle(fontSize: 25, height: 1),
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

    final showcaseCtrl = _showcaseCtrl.of(context);

    final currentKeyframe = showcaseCtrl.currentKeyframe.watch(context);
    final nextKeyframe = showcaseCtrl.nextKeyframe.watch(context);
    final keyframeTransitionProgress = const ElasticInOutCurve(1)
        .transform(showcaseCtrl.keyframeTransitionProgress.watch(context))
        .clamp(0.0, 1.0);

    return _AppearAnimation(
      beginAt: 0.5,
      endAt: 1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _CodeShowcaseProgressStep(
            key: ValueKey(currentKeyframe),
            keyframe: currentKeyframe,
            descriptionVisibilityFactor: 0,
            opacity: 1 - keyframeTransitionProgress,
            translateY: -16 * keyframeTransitionProgress,
          ),
          if (currentKeyframe != nextKeyframe)
            _CodeShowcaseProgressStep(
              key: ValueKey(nextKeyframe),
              keyframe: nextKeyframe,
              descriptionVisibilityFactor: 0,
              opacity: keyframeTransitionProgress,
              translateY: 16 * (1 - keyframeTransitionProgress),
            ),
        ],
      ),
    );
  }
}

class _CodeShowcaseProgressStep extends StatelessWidget {
  const _CodeShowcaseProgressStep({
    super.key,
    required this.keyframe,
    this.translateY,
    this.opacity,
    this.descriptionVisibilityFactor,
  });

  final ShowcaseKeyframe keyframe;
  final double? translateY;
  final double? opacity;
  final double? descriptionVisibilityFactor;

  @override
  Widget build(BuildContext context) {
    final showcaseCtrl = _showcaseCtrl.of(context);

    final expandCtrl = _mobileExpandShowcaseStepDescriptionCtrl.of(context);
    final expandProgress = expandCtrl?.watch(context);

    void onTap() {
      if (showcaseCtrl.currentKeyframe.value != keyframe) {
        showcaseCtrl.animateToKeyframe(keyframe);
      } else if (expandCtrl != null) {
        expandCtrl.isDismissed ? expandCtrl.forward() : expandCtrl.reverse();
      }
    }

    return Transform.translate(
      offset: translateY != null ? Offset(0, translateY!) : Offset.zero,
      child: Opacity(
        opacity: opacity ?? 1,
        child: switch (keyframe) {
          ShowcaseKeyframe.vanillaFlutter => _VanillaFlutterProgressStep(
              descriptionVisibilityFactor:
                  expandProgress ?? descriptionVisibilityFactor ?? 1,
              onTap: onTap,
            ),
          ShowcaseKeyframe.ref => _RefProgressStep(
              descriptionVisibilityFactor:
                  expandProgress ?? descriptionVisibilityFactor ?? 1,
              onTap: onTap,
            ),
          ShowcaseKeyframe.bind => _BindProgressStep(
              descriptionVisibilityFactor:
                  expandProgress ?? descriptionVisibilityFactor ?? 1,
              onTap: onTap,
            ),
          ShowcaseKeyframe.watch => _WatchProgressStep(
              descriptionVisibilityFactor:
                  expandProgress ?? descriptionVisibilityFactor ?? 1,
              onTap: onTap,
            ),
        },
      ),
    );
  }
}

class _VanillaFlutterProgressStep extends StatelessWidget {
  const _VanillaFlutterProgressStep({
    required this.descriptionVisibilityFactor,
    required this.onTap,
  });

  final double descriptionVisibilityFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ProgressStep(
      descriptionVisibilityFactor: descriptionVisibilityFactor,
      onTap: onTap,
      title: const TextSpan(
        children: [
          TextSpan(text: '👋 Meet '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'context_plus'),
            ),
          ),
          TextSpan(text: '!'),
        ],
      ),
      description: const TextSpan(
        children: [
          TextSpan(text: 'See this bulky piece of pure Flutter code?'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'We can halve it!'),
          TextSpan(text: '\n'),
          TextSpan(text: 'Let me show you how. 🚀'),
        ],
      ),
    );
  }
}

class _RefProgressStep extends StatelessWidget {
  const _RefProgressStep({
    required this.descriptionVisibilityFactor,
    required this.onTap,
  });

  final double descriptionVisibilityFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ProgressStep(
      descriptionVisibilityFactor: descriptionVisibilityFactor,
      onTap: onTap,
      title: const TextSpan(
        children: [
          TextSpan(text: '🔗 Create a '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'Ref'),
            ),
          ),
        ],
      ),
      description: const TextSpan(
        children: [
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'Ref', genericTypes: ['T']),
            ),
          ),
          TextSpan(text: ' is a reference to a value of type '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'T'),
            ),
          ),
          TextSpan(text: ' provided by a parent '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'BuildContext'),
            ),
          ),
          TextSpan(text: '.'),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'It behaves similarly to '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'InheritedWidget'),
            ),
          ),
          TextSpan(
            text: ' with a single value property and provides a conventional ',
          ),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'of', params: [
                CodeParameter(name: 'context'),
              ]),
            ),
          ),
          TextSpan(text: ' method to access the value.'),
          TextSpan(text: '\n\n'),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(
                type: 'Ref',
                genericTypes: [
                  '{Stream|Future|Listenable|ValueListenable|AsyncListenable}'
                ],
              ),
            ),
          ),
          TextSpan(text: ' also provides\n'),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'watch'),
            ),
          ),
          TextSpan(text: ' and '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'watchOnly'),
            ),
          ),
          TextSpan(text: ' methods to observe the value conveniently.'),
          TextSpan(text: '\n\n'),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'Ref'),
            ),
          ),
          TextSpan(text: ' can be bound only to a single value per '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'BuildContext'),
            ),
          ),
          TextSpan(text: '. Child contexts can override their parents\' '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'Ref'),
            ),
          ),
          TextSpan(text: ' bindings.'),
          TextSpan(text: '\n\n'),
          TextSpan(text: '👋 Bye, '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'InheritedWidget'),
            ),
          ),
          TextSpan(text: '!'),
        ],
      ),
    );
  }
}

class _BindProgressStep extends StatelessWidget {
  const _BindProgressStep({
    required this.descriptionVisibilityFactor,
    required this.onTap,
  });

  final double descriptionVisibilityFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ProgressStep(
      descriptionVisibilityFactor: descriptionVisibilityFactor,
      onTap: onTap,
      title: const TextSpan(
        children: [
          TextSpan(text: '🤝 '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'bind'),
            ),
          ),
          TextSpan(text: ' it to a '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'BuildContext'),
            ),
          ),
        ],
      ),
      description: const TextSpan(
        children: [
          WidgetSpan(
            child: CodeQuote(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeType(type: 'Ref'),
                  CodeFunctionCall(
                    name: 'bind',
                    params: [
                      CodeParameter(name: 'context'),
                      Text('() => ...'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Binds a '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeType(type: 'Ref'),
                  ),
                ),
                TextSpan(text: ' to the '),
                TextSpan(
                  text: 'value initializer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(
                  text: 'Value initialization happens immediately.',
                ),
                TextSpan(text: ' Use '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeFunctionCall(name: 'bindLazy'),
                  ),
                ),
                TextSpan(text: ' if you need it lazy.'),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Value is '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeFunctionCall(name: 'dispose'),
                  ),
                ),
                TextSpan(
                  text: '\'d automatically when the widget is disposed.',
                ),
                TextSpan(text: ' Provide a '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeParameter(name: 'dispose'),
                  ),
                ),
                TextSpan(
                  text: ' callback to customize the disposal if needed.',
                ),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Similarly to widgets, '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeParameter(name: 'key'),
                  ),
                ),
                TextSpan(
                  text:
                      ' parameter allows for updating the value initializer when needed.',
                ),
              ],
            ),
          ),
          TextSpan(text: '\n\n'),
          WidgetSpan(
            child: CodeQuote(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeType(type: 'Ref'),
                  CodeFunctionCall(
                    name: 'bindValue',
                    params: [
                      CodeParameter(name: 'context'),
                      Text('...'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Binds the '),
                TextSpan(
                  text: 'value',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to the '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeParameter(name: 'context'),
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(
                  text:
                      'Whenever the value changes, the dependent widgets will be automatically rebuilt.',
                ),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Values provided this way are '),
                TextSpan(
                  text: 'not',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' disposed automatically.'),
              ],
            ),
          ),
          TextSpan(text: '\n\n'),
          TextSpan(text: '👋 Bye, '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'StatefulWidget'),
            ),
          ),
          TextSpan(text: '!'),
        ],
      ),
    );
  }
}

class _WatchProgressStep extends StatelessWidget {
  const _WatchProgressStep({
    required this.descriptionVisibilityFactor,
    required this.onTap,
  });

  final double descriptionVisibilityFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ProgressStep(
      descriptionVisibilityFactor: descriptionVisibilityFactor,
      onTap: onTap,
      title: const TextSpan(
        children: [
          TextSpan(text: '👀 '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'watch'),
            ),
          ),
          TextSpan(text: ' it from a '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'BuildContext'),
            ),
          ),
        ],
      ),
      description: const TextSpan(
        children: [
          WidgetSpan(
            child: CodeQuote(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeType(
                    type:
                        '{Stream|Future|Listenable|ValueListenable|AsyncListenable}',
                  ),
                  CodeFunctionCall(
                    name: 'watch',
                    params: [CodeParameter(name: 'context')],
                  ),
                ],
              ),
            ),
          ),
          TextSpan(text: '\n'),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(text: 'Rebuilds the '),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeParameter(name: 'context'),
                  ),
                ),
                TextSpan(
                  text: ' whenever the observable value notifies of changes.',
                ),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(
                  text:
                      'Provides the same data as the corresponding builder widget.',
                ),
              ],
            ),
          ),
          WidgetSpan(
            child: _DescriptionBulletPoint(
              children: [
                TextSpan(
                  text: 'When more granular rebuild control is desired, use ',
                ),
                WidgetSpan(
                  child: CodeQuote(
                    child: CodeFunctionCall(name: 'watchOnly'),
                  ),
                ),
                TextSpan(
                  text:
                      ', which rebuilds the widget only if the selected value changes.',
                ),
              ],
            ),
          ),
          TextSpan(text: '\n\n'),
          TextSpan(text: 'For even more convenience, '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(type: 'Ref'),
            ),
          ),
          TextSpan(text: 's to the same observable types also provide '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'watch'),
            ),
          ),
          TextSpan(text: ' and '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeFunctionCall(name: 'watchOnly'),
            ),
          ),
          TextSpan(text: ' methods.\n\n'),
          TextSpan(text: '👋 Bye, '),
          WidgetSpan(
            child: CodeQuote(
              child: CodeType(
                type:
                    '{Stream|Future|Listenable|ValueListenable|AsyncListenable}Builder',
              ),
            ),
          ),
          TextSpan(text: '!'),
        ],
      ),
    );
  }
}

class _ShortPackageDescription extends StatelessWidget {
  const _ShortPackageDescription();

  @override
  Widget build(BuildContext context) {
    final isShowcaseCompleted = _isShowcaseCompleted.watch(context);
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      offset: Offset(0, isShowcaseCompleted ? 0 : 0.1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        opacity: isShowcaseCompleted ? 1 : 0,
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
            const SizedBox(height: 4),
            const AnimatedArrowDown(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// region Utils

class _DescriptionBulletPoint extends StatelessWidget {
  const _DescriptionBulletPoint({
    required this.children,
  });

  final List<InlineSpan> children;

  @override
  Widget build(BuildContext context) {
    return BulletPoint(
      bulletTopMargin: 8,
      child: SizedBox(
        width: 246,
        child: Text.rich(
          TextSpan(
            children: children,
          ),
        ),
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.title,
    required this.description,
    required this.descriptionVisibilityFactor,
    required this.onTap,
  });

  final InlineSpan title;
  final InlineSpan description;
  final double descriptionVisibilityFactor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final layout = _showcaseLayout.of(context);
    final isMobile = layout == _ShowcaseLayout.mobile;

    final titleMargin = isMobile
        ? const EdgeInsets.symmetric(horizontal: 8)
        : const EdgeInsets.only(top: 0);

    final displayShadow = isMobile;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (displayShadow)
          const SizedBox(
            height: 56,
            child: _Shadow(),
          ),
        Material(
          color: displayShadow
              ? _mobileShowcaseStepBackgroundColor
              : Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: titleMargin,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextStyle.merge(
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                            child: Text.rich(title),
                          ),
                        ),
                        if (isMobile) ...[
                          const Gap(2),
                          Transform.rotate(
                            angle: descriptionVisibilityFactor * 0.5 * 2 * pi,
                            child: const Icon(
                              MdiIcons.chevronUp,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: isMobile
                    ? const EdgeInsets.only(left: 16, right: 16, bottom: 16)
                    : const EdgeInsets.only(left: 34),
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: 1,
                    heightFactor: descriptionVisibilityFactor,
                    child: Opacity(
                      opacity: descriptionVisibilityFactor,
                      child: Card(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        color: const Color(0xFF111111),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey[300]),
                            child: Text.rich(description),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

enum _ShadowDirection { top, bottom }

class _Shadow extends StatelessWidget {
  const _Shadow({
    this.direction = _ShadowDirection.bottom,
  });

  final _ShadowDirection direction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: switch (direction) {
            _ShadowDirection.top => [
                const Color(0xDD000000),
                const Color(0x00000000),
              ],
            _ShadowDirection.bottom => [
                const Color(0x00000000),
                const Color(0xDD000000),
              ],
          },
        ),
      ),
    );
  }
}

double _watchKeyframeTransitionProgress({
  required BuildContext context,
  required ShowcaseKeyframe keyframe,
}) {
  final ctrl = _showcaseCtrl.of(context);

  final currentKeyframe = ctrl.currentKeyframe.watch(context);
  final nextKeyframe = ctrl.nextKeyframe.watch(context);
  final keyframeTransitionProgress = const ElasticInOutCurve(1).transform(
    ctrl.keyframeTransitionProgress.watch(context).clamp(0.0, 1.0),
  );

  final progress = switch (keyframe) {
    _ when keyframe == currentKeyframe => 1 - keyframeTransitionProgress,
    _ when keyframe == nextKeyframe => keyframeTransitionProgress,
    _ => 0.0,
  }
      .clamp(0.0, 1.0);

  return progress;
}

// endregion
