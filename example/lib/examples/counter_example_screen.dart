import 'package:flutter/material.dart';

import '../other/example.dart';
import 'counter/context_plus_bind_watch_value_example.dart'
    as context_plus_bind_watch_value;
import 'counter/stateful_widget.dart' as stateful_widget;

class CounterExampleScreen extends StatelessWidget {
  const CounterExampleScreen({super.key});

  static const title = 'Counter';
  static const urlPath = '/counter_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus: ValueNotifier + Ref.bind() + Ref.watchValue()',
          filePath: 'counter/context_plus_bind_watch_value_example.dart',
          widget: Center(
            child: context_plus_bind_watch_value.Example(),
          ),
        ),
        ExampleVariant(
          title: 'StatefulWidget',
          filePath: 'counter/stateful_widget.dart',
          widget: Center(
            child: stateful_widget.Example(),
          ),
        ),
      ],
    );
  }
}
