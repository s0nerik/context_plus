import 'dart:math';

import 'package:flutter/material.dart';

class HaloBox extends StatefulWidget {
  const HaloBox({
    super.key,
    required this.width,
    required this.height,
    required this.opacity,
    required this.child,
  });

  final double width;
  final double height;
  final double opacity;
  final Widget child;

  @override
  State<HaloBox> createState() => _HaloBoxState();
}

class _HaloBoxState extends State<HaloBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      willChange: true,
      painter: _LissajousOrbitPainter(
        animation: _controller,
        opacity: widget.opacity,
      ),
      child: widget.child,
    );
  }
}

class _LissajousOrbitPainter extends CustomPainter {
  _LissajousOrbitPainter({
    required this.animation,
    required this.opacity,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final amplitude = size.width * 0.1;

    const colors = [Colors.red, Colors.green, Colors.blue, Colors.purple];

    for (int i = 0; i < 4; i++) {
      final t = animation.value * 2 * pi + i * 2 * pi / 3;
      final x = center.dx + amplitude * sin(3 * t + i * pi / 3);
      final y = center.dy + amplitude * sin(2 * t);

      final paint = Paint()
        ..color = colors[i].withOpacity(0.4 * opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_LissajousOrbitPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.animation != animation;
}
