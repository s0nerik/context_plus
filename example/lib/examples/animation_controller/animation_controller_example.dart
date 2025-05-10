import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

import 'variants/animated_builder.dart' as animated_builder;
import 'variants/context_plus.dart' as context_plus;
import 'variants/context_use.dart' as context_use;
import 'variants/context_watch.dart' as context_watch;

class AnimationControllerExample extends StatelessWidget {
  const AnimationControllerExample({super.key});

  static const title = 'AnimationController';
  static const description =
      'Example that shows different ways to initialize and use an AnimationController.';
  static const tags = [
    'context.use()',
    'Ref.bind()',
    'Ref.watch()',
    'ValueListenable.watch()',
  ];

  static const urlPath = '/animation_controller_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'animation_controller',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_use.dart',
          title: 'context.use() + .watch()',
          widget: Center(child: context_use.Example()),
        ),
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'Ref.bind() + Ref.watch()',
          widget: Center(child: context_plus.Example()),
        ),
        ExampleVariant(
          file: 'context_watch.dart',
          title: 'AnimationController.watch()',
          widget: Center(child: context_watch.Example()),
        ),
        ExampleVariant(
          file: 'animated_builder.dart',
          title: 'AnimatedBuilder',
          widget: Center(child: animated_builder.Example()),
        ),
      ],
    );
  }
}
