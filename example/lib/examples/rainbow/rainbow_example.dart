import 'package:flutter/material.dart';

import '../../other/example.dart';
import 'variants/context_plus.dart' as context_plus;
import 'variants/stateful_widget.dart' as stateful_widget;

class RainbowExample extends StatelessWidget {
  const RainbowExample({super.key});

  static const title = 'Rainbow example';
  static const description =
      'A slightly more complicated example that shows how various things can be provided and observed at the same time.';
  static const tags = ['Ref.bind()', 'Ref.bindValue()', 'Ref.of(context)'];

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
