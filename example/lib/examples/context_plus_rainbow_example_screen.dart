import 'package:flutter/material.dart';

import '../other/example.dart';
import 'context_plus_rainbow/context_plus_example.dart' as context_plus;
import 'context_plus_rainbow/stateful_widget_example.dart' as stateful_widget;

class ContextPlusBindWatchExampleScreen extends StatelessWidget {
  const ContextPlusBindWatchExampleScreen({super.key});

  static const title = 'Rainbow example';
  static const urlPath = '/context_plus_bind_watch_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'context_plus_rainbow/context_plus_example.dart',
          widget: context_plus.Example(),
        ),
        ExampleVariant(
          title: 'StatefulWidget',
          filePath: 'context_plus_rainbow/stateful_widget_example.dart',
          widget: stateful_widget.Example(),
        ),
      ],
    );
  }
}
