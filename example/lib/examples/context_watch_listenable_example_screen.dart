import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

import 'context_watch_listenable/context_watch_example.dart' as context_watch;
import 'context_watch_listenable/listenable_builder_example.dart'
    as listenable_builder;

class ContextWatchListenableExampleScreen extends StatelessWidget {
  const ContextWatchListenableExampleScreen({super.key});

  static const title = 'Listenable.watch()';
  static const urlPath = '/context_watch_listenable_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_watch',
          filePath: 'context_watch_listenable/context_watch_example.dart',
          widget: Center(
            child: context_watch.Example(),
          ),
        ),
        ExampleVariant(
          title: 'AnimatedBuilder',
          filePath: 'context_watch_listenable/listenable_builder_example.dart',
          widget: Center(
            child: listenable_builder.Example(),
          ),
        ),
      ],
    );
  }
}
