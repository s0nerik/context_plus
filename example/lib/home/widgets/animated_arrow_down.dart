import 'dart:math' as math;

import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

class AnimatedArrowDown extends StatelessWidget {
  const AnimatedArrowDown({super.key});

  static final _animCtrl = Ref<AnimationController>();

  @override
  Widget build(BuildContext context) {
    final animCtrl = _animCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 2),
      )..repeat(),
    );

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CustomPaint(
          willChange: true,
          painter: ScrollDownArrowsPainter(animation: animCtrl),
        ),
      ),
    );
  }
}

class ScrollDownArrowsPainter extends CustomPainter {
  ScrollDownArrowsPainter({required this.animation})
      : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arrowWidth = size.width * 0.6;
    final arrowHeight = size.height * 0.25;

    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + i / 3) % 1.0;
      final yOffset = progress * size.height;

      // Calculate opacity
      final fadeDistance = size.height * 0.5;
      final topFade = yOffset.clamp(0.0, fadeDistance) / fadeDistance;
      final bottomFade =
          (size.height - yOffset * 1.1).clamp(0.0, fadeDistance) / fadeDistance;
      final opacity = math.min(topFade, bottomFade);

      paint.color = Colors.white.withValues(alpha: opacity);

      final path = Path()
        ..moveTo(size.width / 2 - arrowWidth / 2, yOffset)
        ..lineTo(size.width / 2, yOffset + arrowHeight)
        ..lineTo(size.width / 2 + arrowWidth / 2, yOffset);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
