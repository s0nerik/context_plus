import 'package:flutter/material.dart';

import '../other/example.dart';
import 'context_plus_screen_state/context_plus_example.dart' as context_plus;

class ContextPlusScreenStateExampleScreen extends StatelessWidget {
  const ContextPlusScreenStateExampleScreen({super.key});

  static const title = 'Screen state';
  static const urlPath = '/context_plus_screen_state_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'context_plus_screen_state/context_plus_example.dart',
          widget: context_plus.Example(),
        ),
      ],
    );
  }
}
