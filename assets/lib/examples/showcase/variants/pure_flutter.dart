import 'package:flutter/material.dart';

import '../util/observables.dart';

class _InheritedState extends InheritedWidget {
  const _InheritedState({
    required this.scaleController,
    required this.colorStream,
    required super.child,
  });

  final AnimationController scaleController;
  final Stream<Color> colorStream;

  @override
  bool updateShouldNotify(_InheritedState oldWidget) =>
      oldWidget.scaleController != scaleController ||
      oldWidget.colorStream != colorStream;

  static _InheritedState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedState>()!;
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with SingleTickerProviderStateMixin {
  late final Stream<Color> _colorStream = createColorStream();
  late final AnimationController _scaleController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(min: 0.5, max: 1, reverse: true);

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedState(
      scaleController: _scaleController,
      colorStream: _colorStream,
      child: const _AnimatedFlutterLogo(),
    );
  }
}

class _AnimatedFlutterLogo extends StatelessWidget {
  const _AnimatedFlutterLogo();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _InheritedState.of(context).colorStream,
      builder:
          (context, colorSnapshot) => ValueListenableBuilder(
            valueListenable: _InheritedState.of(context).scaleController,
            builder:
                (context, scale, _) => Transform.scale(
                  scale: scale,
                  child: FlutterLogo(
                    size: 200,
                    style: FlutterLogoStyle.stacked,
                    textColor: colorSnapshot.data ?? Colors.transparent,
                  ),
                ),
          ),
    );
  }
}
