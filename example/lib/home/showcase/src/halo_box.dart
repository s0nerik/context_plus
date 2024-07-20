import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HaloBox extends StatefulWidget {
  const HaloBox({
    super.key,
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  State<HaloBox> createState() => _HaloBoxState();
}

class _HaloBoxState extends State<HaloBox> {
  static const _duration = Duration(milliseconds: 1000);
  static final colors = [
    Colors.yellow,
    Colors.green,
    Colors.purple[300]!,
    Colors.blue,
  ];

  final _rnd = Random();
  late Timer _timer;

  late List<_Gradient> _gradients;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_duration, _onTimerTick);
    _onTimerTick(null);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTimerTick(_) {
    if (!mounted) return;
    setState(() {
      const positionFraction = 0.2;
      const sizeFraction = 1.35;
      _gradients = List.generate(4, (i) {
        final color = colors[i];
        final gradient = _Gradient(
          color: color,
          left: i % 2 == 0 ? _rnd.nextDouble() * positionFraction : null,
          right: i % 2 == 1 ? _rnd.nextDouble() * positionFraction : null,
          top: i < 2 ? _rnd.nextDouble() * positionFraction : null,
          bottom: i >= 2 ? _rnd.nextDouble() * positionFraction : null,
          width: sizeFraction + 0.2 * _rnd.nextDouble(),
          height: sizeFraction + 0.2 * _rnd.nextDouble(),
        );
        return gradient;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: Size(widget.width, widget.height),
      child: UnconstrainedBox(
        clipBehavior: Clip.none,
        child: SizedBox(
          width: widget.width * 2,
          height: widget.height * 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final gradient in _gradients)
                AnimatedPositioned(
                  duration: _duration,
                  left: gradient.left != null
                      ? widget.width * gradient.left!
                      : null,
                  top: gradient.top != null
                      ? widget.height * gradient.top!
                      : null,
                  right: gradient.right != null
                      ? widget.width * gradient.right!
                      : null,
                  bottom: gradient.bottom != null
                      ? widget.height * gradient.bottom!
                      : null,
                  width: gradient.width * widget.width,
                  height: gradient.height * widget.height,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          gradient.color.withOpacity(0.4 * widget.opacity),
                          gradient.color.withOpacity(0.0),
                        ],
                        radius: 0.4,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// All values except color are fractions
class _Gradient {
  const _Gradient({
    required this.color,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.width,
    required this.height,
  });

  final Color color;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double width;
  final double height;
}
