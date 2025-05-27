import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final animCtrl = context.use(
      () => AnimationController(
        vsync: context.vsync,
        duration: const Duration(seconds: 1),
      )..repeat(min: 0.5, max: 1, reverse: true),
    );
    return Transform.scale(
      scale: animCtrl.watch(context),
      child: const FlutterLogo(size: 200),
    );
  }
}
