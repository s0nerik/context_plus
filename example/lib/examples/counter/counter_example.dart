import 'package:flutter/material.dart';

import '../../other/example.dart';
import 'variants/context_plus.dart' as context_plus_bind_watch_value;
import 'variants/stateful_widget.dart' as stateful_widget;

class CounterExample extends StatelessWidget {
  const CounterExample({super.key});

  static const title = 'Counter';
  static const urlPath = '/counter_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'counter',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'context_plus: ValueNotifier + Ref.bind() + Ref.watch()',
          widget: Center(
            child: context_plus_bind_watch_value.Example(),
          ),
        ),
        ExampleVariant(
          file: 'stateful_widget.dart',
          title: 'StatefulWidget',
          widget: Center(
            child: stateful_widget.Example(),
          ),
        ),
      ],
    );
  }
}
