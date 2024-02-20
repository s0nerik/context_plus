import 'package:flutter/material.dart';

import '../other/example.dart';
import 'context_ref_bind/context_ref_example.dart' as context_ref;
import 'context_ref_bind/inherited_widget_example.dart' as inherited_widget;

class BindExampleScreen extends StatelessWidget {
  const BindExampleScreen({super.key});

  static const title = 'Ref.bind()';
  static const urlPath = '/context_ref_bind_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_ref',
          filePath: 'context_ref_bind/context_ref_example.dart',
          widget: context_ref.Example(),
        ),
        ExampleVariant(
          title: 'InheritedWidget',
          filePath: 'context_ref_bind/inherited_widget_example.dart',
          widget: inherited_widget.Example(),
        ),
      ],
    );
  }
}
