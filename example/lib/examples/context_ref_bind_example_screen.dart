import 'package:flutter/material.dart';

import '../example.dart';
import 'context_ref_bind_example.dart';

class BindExampleScreen extends StatelessWidget {
  const BindExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ref.bind()'),
      ),
      body: const ExampleScaffold(
        title: 'Ref.bind()',
        variants: [
          ExampleVariant(
            title: 'Ref.bind()',
            filePath: 'context_ref_bind_example.dart',
            widget: BindExample(),
          ),
        ],
      ),
    );
  }
}
