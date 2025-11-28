import 'dart:async';

import 'package:context_plus/context_plus.dart';
import 'package:example/home/showcase/code_showcase.dart';
import 'package:example/home/showcase/intro.dart';
import 'package:flutter/material.dart';

import 'src/code.dart';

class PackageShowcase extends StatelessWidget {
  const PackageShowcase({
    super.key,
    required this.homeScrollController,
    required this.codeAnimationController,
    required this.onIntroComplete,
    required this.onIntroSkip,
    required this.onCodeShowcaseAppeared,
  });

  final ScrollController homeScrollController;
  final CodeAnimationController codeAnimationController;
  final VoidCallback onIntroComplete;
  final VoidCallback onIntroSkip;
  final VoidCallback onCodeShowcaseAppeared;

  @override
  Widget build(BuildContext context) {
    final isIntroCompleted = context.use(() {
      scheduleMicrotask(onIntroComplete);
      return ValueNotifier(true);
    });
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        const RepaintBoundary(child: CustomPaint(willChange: false, isComplex: true, painter: _BlueprintPainter())),
        if (!isIntroCompleted.watch(context))
          Intro(
            onComplete: () {
              isIntroCompleted.value = true;
              onIntroComplete();
            },
            onSkip: () {
              isIntroCompleted.value = true;
              onIntroSkip();
            },
          )
        else
          SafeArea(
            child: CodeShowcase(
              homeScrollController: homeScrollController,
              codeAnimationController: codeAnimationController,
              onAppeared: onCodeShowcaseAppeared,
            ),
          ),
      ],
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
