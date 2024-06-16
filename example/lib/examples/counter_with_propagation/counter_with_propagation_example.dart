import 'package:flutter/material.dart';

import '../../other/example.dart';
import 'variants/context_plus_bind_watch.dart' as context_plus_bind_watch_value;
import 'variants/context_plus_stateful_bind_value.dart'
    as context_plus_stateful_bind_value;
import 'variants/stateful_widget_explicit_params.dart'
    as stateful_widget_explicit_params;
import 'variants/stateful_widget_inherited_widget.dart'
    as stateful_widget_inherited_widget;

class CounterWithPropagationExample extends StatelessWidget {
  const CounterWithPropagationExample({super.key});

  static const title = 'Counter (with propagation)';
  static const description =
      'Counter example where the counter value getter/setter has to be propagated to the child widgets.';
  static const tags = [
    'Ref.bind()',
    'Ref.bindValue()',
    'Ref.of(context)',
    'Ref.watch()',
  ];

  static const urlPath = '/counter_with_propagation_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'counter_with_propagation',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus_bind_watch.dart',
          title: 'context_plus: ValueNotifier + Ref.bind() + Ref.watch()',
          widget: Center(
            child: context_plus_bind_watch_value.Example(),
          ),
        ),
        ExampleVariant(
          file: 'context_plus_stateful_bind_value.dart',
          title:
              'context_plus: StatefulWidget + Ref.bindValue() + Ref.of(context)',
          widget: Center(
            child: context_plus_stateful_bind_value.Example(),
          ),
        ),
        ExampleVariant(
          file: 'stateful_widget_explicit_params.dart',
          title: 'StatefulWidget (explicit params propagation)',
          widget: Center(
            child: stateful_widget_explicit_params.Example(),
          ),
        ),
        ExampleVariant(
          file: 'stateful_widget_inherited_widget.dart',
          title: 'StatefulWidget + InheritedWidget',
          widget: Center(
            child: stateful_widget_inherited_widget.Example(),
          ),
        ),
      ],
    );
  }
}
