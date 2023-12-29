import 'package:flutter/material.dart';

import '../example.dart';
import '../examples/bind_example.dart';

class BindExampleScreen extends StatelessWidget {
  const BindExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ref.bind() example'),
      ),
      body: const Example(
        title: 'Ref.bind()',
        fileName: 'bind_example.dart',
        child: BindExample(),
      ),
    );
  }
}
