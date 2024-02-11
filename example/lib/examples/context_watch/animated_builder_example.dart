import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with SingleTickerProviderStateMixin {
  late final _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(min: 0.5, max: 1, reverse: true);

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) => Transform.scale(
        scale: _animCtrl.value,
        child: const FlutterLogo(size: 200),
      ),
    );
  }
}
