import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

import 'variants/context_plus.dart' as context_plus;
import 'variants/pure_flutter.dart' as pure_flutter;

class ShowcaseExample extends StatelessWidget {
  const ShowcaseExample({super.key});

  static const title = 'Showcase';
  static const description =
      'Example using the code showcased on the animation at the top of the home page.';
  static const tags = [
    'Ref.bind()',
    'Ref.watch()',
  ];

  static const urlPath = '/showcase_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'showcase',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'context_plus',
          widget: Center(
            child: context_plus.Example(),
          ),
        ),
        ExampleVariant(
          file: 'pure_flutter.dart',
          title: 'Pure Flutter',
          widget: Center(
            child: pure_flutter.Example(),
          ),
        ),
      ],
    );
  }
}
