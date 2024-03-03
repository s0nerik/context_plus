import 'package:flutter/material.dart';

import '../other/example.dart';
import 'rainbow/context_plus_example.dart' as context_plus;
import 'rainbow/stateful_widget_example.dart' as stateful_widget;

class RainbowExampleScreen extends StatelessWidget {
  const RainbowExampleScreen({super.key});

  static const title = 'Rainbow example';
  static const urlPath = '/rainbow_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'rainbow/context_plus_example.dart',
          widget: context_plus.Example(),
        ),
        ExampleVariant(
          title: 'StatefulWidget',
          filePath: 'rainbow/stateful_widget_example.dart',
          widget: stateful_widget.Example(),
        ),
      ],
    );
  }
}
