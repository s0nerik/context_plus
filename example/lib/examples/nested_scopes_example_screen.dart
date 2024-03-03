import 'package:flutter/material.dart';

import 'nested_scopes/context_plus.dart' as context_plus;

import '../other/example.dart';

class NestedScopesExampleScreen extends StatelessWidget {
  const NestedScopesExampleScreen({super.key});

  static const title = 'Nested scopes';
  static const urlPath = '/nested_scopes_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'nested_scopes/context_plus.dart',
          widget: Center(
            child: context_plus.Example(),
          ),
        ),
      ],
    );
  }
}
