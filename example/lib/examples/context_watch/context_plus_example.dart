import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../other/context_animation_controller.dart';

final _animCtrl = Ref<AnimationController>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _animCtrl.bind(
      context,
      () => ContextAnimationController(
        context: context,
        duration: const Duration(seconds: 1),
      )..repeat(min: 0.5, max: 1, reverse: true),
    );
    return Transform.scale(
      scale: _animCtrl.watch(context),
      child: const FlutterLogo(size: 200),
    );
  }
}
