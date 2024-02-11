import 'package:example/example.dart';
import 'package:flutter/material.dart';

import 'context_watch/context_watch_example.dart' as context_watch;

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
          title: 'Anything.watch()',
          filePath: 'context_watch/context_watch_example.dart',
          widget: context_watch.Example(),
        ),
      ],
    );
  }
}
