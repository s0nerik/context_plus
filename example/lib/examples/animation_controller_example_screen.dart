import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

import 'animation_controller/animated_builder_example.dart' as animated_builder;
import 'animation_controller/context_watch_example.dart' as context_watch;
import 'animation_controller/context_plus_example.dart' as context_plus;

class AnimationControllerExampleScreen extends StatelessWidget {
  const AnimationControllerExampleScreen({super.key});

  static const title = 'AnimationController';
  static const urlPath = '/animation_controller_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'animation_controller/context_plus_example.dart',
          widget: Center(
            child: context_plus.Example(),
          ),
        ),
        ExampleVariant(
          title: 'animation_controller',
          filePath: 'animation_controller/context_watch_example.dart',
          widget: Center(
            child: context_watch.Example(),
          ),
        ),
        ExampleVariant(
          title: 'AnimatedBuilder',
          filePath: 'animation_controller/animated_builder_example.dart',
          widget: Center(
            child: animated_builder.Example(),
          ),
        ),
      ],
    );
  }
}
