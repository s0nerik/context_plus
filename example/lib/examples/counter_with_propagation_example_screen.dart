import 'package:flutter/material.dart';

import '../other/example.dart';
import 'counter_with_propagation/context_plus_bind_watch_value_example.dart'
    as context_plus_bind_watch_value;
import 'counter_with_propagation/stateful_widget_explicit_params.dart'
    as stateful_widget_explicit_params;
import 'counter_with_propagation/stateful_widget_inherited_widget.dart'
    as stateful_widget_inherited_widget;

class CounterWithPropagationExampleScreen extends StatelessWidget {
  const CounterWithPropagationExampleScreen({super.key});

  static const title = 'Counter (with propagation)';
  static const urlPath = '/counter_with_propagation_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus: ValueNotifier + Ref.bind() + Ref.watchValue()',
          filePath:
              'counter_with_propagation/context_plus_bind_watch_value_example.dart',
          widget: Center(
            child: context_plus_bind_watch_value.Example(),
          ),
        ),
        ExampleVariant(
          title: 'StatefulWidget (explicit params propagation)',
          filePath:
              'counter_with_propagation/stateful_widget_explicit_params.dart',
          widget: Center(
            child: stateful_widget_explicit_params.Example(),
          ),
        ),
        ExampleVariant(
          title: 'StatefulWidget + InheritedWidget',
          filePath:
              'counter_with_propagation/stateful_widget_inherited_widget.dart',
          widget: Center(
            child: stateful_widget_inherited_widget.Example(),
          ),
        ),
      ],
    );
  }
}
