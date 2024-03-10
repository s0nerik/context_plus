import 'package:flutter/material.dart';

import '../../other/example.dart';
import 'variants/context_plus.dart' as context_plus;
import 'variants/stateful_widget.dart' as stateful_widget;

class RainbowExample extends StatelessWidget {
  const RainbowExample({super.key});

  static const title = 'Rainbow example';
  static const urlPath = '/rainbow_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'rainbow',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'context_plus',
          widget: context_plus.Example(),
        ),
        ExampleVariant(
          file: 'stateful_widget.dart',
          title: 'StatefulWidget',
          widget: stateful_widget.Example(),
        ),
      ],
    );
  }
}
