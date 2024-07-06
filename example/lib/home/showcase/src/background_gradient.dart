import 'package:flutter/material.dart';

enum BackgroundGradientDirection { top, bottom }

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({
    super.key,
    this.direction = BackgroundGradientDirection.bottom,
  });

  final BackgroundGradientDirection direction;

  static const startColor = Color(0x00000000);
  static const endColor = Color(0xDD000000);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: switch (direction) {
            BackgroundGradientDirection.top => const [endColor, startColor],
            BackgroundGradientDirection.bottom => const [startColor, endColor],
          },
        ),
      ),
    );
  }
}
