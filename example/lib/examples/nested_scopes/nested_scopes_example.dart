import 'package:flutter/material.dart';

import 'variants/context_plus.dart' as context_plus;

import '../../other/example.dart';

class NestedScopesExample extends StatelessWidget {
  const NestedScopesExample({super.key});

  static const title = 'Nested scopes demonstration';
  static const description =
      'Example demonstrating that Ref values are always provided by the nearest ancestor and can be overridden by a descendant.';
  static const tags = [
    'Ref.bind()',
    'Ref.bindValue()',
    'Ref.of(context)',
    'ValueListenable.watch()',
  ];

  static const urlPath = '/nested_scopes_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'nested_scopes',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'context_plus',
          widget: Center(child: context_plus.Example()),
        ),
      ],
    );
  }
}
