import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../util/observables.dart';

final _scaleController = Ref<AnimationController>();
final _colorStream = Ref<Stream<Color>>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _colorStream.bind(context, createColorStream);
    _scaleController.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 1),
      )..repeat(min: 0.5, max: 1, reverse: true),
    );
    return const _AnimatedFlutterLogo();
  }
}

class _AnimatedFlutterLogo extends StatelessWidget {
  const _AnimatedFlutterLogo();

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleController.watch(context),
      child: FlutterLogo(
        size: 200,
        style: FlutterLogoStyle.stacked,
        textColor: _colorStream.watch(context).data ?? Colors.transparent,
      ),
    );
  }
}
