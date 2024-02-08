import 'package:flutter/material.dart';

import '../example.dart';
import 'context_ref_bind_value/context_ref_example.dart' as context_ref;
import 'context_ref_bind_value/inherited_widget_example.dart'
    as inherited_widget;

class BindValueExampleScreen extends StatelessWidget {
  const BindValueExampleScreen({super.key});

  static const urlPath = '/context_ref_bind_value_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ref.bindValue()'),
      ),
      body: const ExampleScaffold(
        title: 'Ref.bindValue()',
        variants: [
          ExampleVariant(
            title: 'Ref.bindValue()',
            filePath: 'context_ref_bind_value/context_ref_example.dart',
            widget: context_ref.Example(),
          ),
          ExampleVariant(
            title: 'InheritedWidget',
            filePath: 'context_ref_bind_value/inherited_widget_example.dart',
            widget: inherited_widget.Example(),
          ),
        ],
      ),
    );
  }
}
