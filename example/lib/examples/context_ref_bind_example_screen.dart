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
      body: const Example(
        title: 'Ref.bind()',
        children: {
          'context_ref_bind_example.dart': BindExample(),
        },
      ),
    );
  }
}
