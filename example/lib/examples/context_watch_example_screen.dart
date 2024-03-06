import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

import 'context_watch/animated_builder_example.dart' as animated_builder;
import 'context_watch/context_watch_example.dart' as context_watch;
import 'context_watch/context_plus_example.dart' as context_plus;

class ContextWatchExampleScreen extends StatelessWidget {
  const ContextWatchExampleScreen({super.key});

  static const title = 'Anything.watch()';
  static const urlPath = '/context_watch_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'context_watch/context_plus_example.dart',
          widget: Center(
            child: context_plus.Example(),
          ),
        ),
        ExampleVariant(
          title: 'context_watch',
          filePath: 'context_watch/context_watch_example.dart',
          widget: Center(
            child: context_watch.Example(),
          ),
        ),
        ExampleVariant(
          title: 'AnimatedBuilder',
          filePath: 'context_watch/animated_builder_example.dart',
          widget: Center(
            child: animated_builder.Example(),
          ),
        ),
      ],
    );
  }
}
