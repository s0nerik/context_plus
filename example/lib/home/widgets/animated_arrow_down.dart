import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedArrowDown extends StatelessWidget {
  const AnimatedArrowDown({super.key});

  static final _animCtrl = Ref<AnimationController>();
  static final _anim = Ref<SequenceAnimation>();

  @override
  Widget build(BuildContext context) {
    final animCtrl = _animCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 1),
      )..repeat(),
    );

    final anim = _anim.bind(
      context,
      () => SequenceAnimationBuilder()
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration.zero,
            to: const Duration(milliseconds: 300),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: -8, end: 0),
            from: Duration.zero,
            to: const Duration(milliseconds: 300),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 1),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 600),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 0),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 600),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 0),
            from: const Duration(milliseconds: 600),
            to: const Duration(milliseconds: 900),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 8),
            from: const Duration(milliseconds: 600),
            to: const Duration(milliseconds: 900),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 0),
            from: const Duration(milliseconds: 900),
            to: const Duration(milliseconds: 1000),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 8, end: 8),
            from: const Duration(milliseconds: 900),
            to: const Duration(milliseconds: 1000),
            tag: 'translateY',
          )
          .animate(animCtrl),
    );

    return VisibilityDetector(
      key: const Key('AnimatedBottomArrow'),
      onVisibilityChanged: (info) {
        if (!context.mounted) return;
        if (info.visibleFraction == 0) {
          animCtrl.reset();
        } else {
          animCtrl.repeat();
        }
      },
      child: Transform.translate(
        offset: Offset(0, anim['translateY'].watch(context)),
        child: Opacity(
          opacity: anim['opacity'].watch(context),
          child: const Icon(MdiIcons.chevronDoubleDown),
        ),
      ),
    );
  }
}
