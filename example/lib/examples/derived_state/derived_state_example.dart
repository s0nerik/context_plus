import 'package:flutter/material.dart';

import '../../other/example.dart';
import 'variants/context_plus_change_notifier.dart'
    as context_plus_change_notifier;
import 'variants/context_plus_value_notifier_bind_watch.dart'
    as context_plus_value_notifier_bind_watch;
import 'variants/context_plus_value_notifier_function.dart'
    as context_plus_value_notifier_function;

class DerivedStateExample extends StatelessWidget {
  const DerivedStateExample({super.key});

  static const title = 'Derived state';
  static const description =
      'Example that shows various hot reload friendly ways of deriving the state.';
  static const tags = [
    'Ref.bind()',
    'Ref.watch()',
    'Ref.watchOnly()',
    'Ref.of(context)',
  ];

  static const urlPath = '/derived_state_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'derived_state',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus_change_notifier.dart',
          title: 'context_plus: Custom ChangeNotifier',
          widget: context_plus_change_notifier.Example(),
        ),
        ExampleVariant(
          file: 'context_plus_value_notifier_function.dart',
          title: 'context_plus: ValueNotifier + computed function',
          widget: context_plus_value_notifier_function.Example(),
        ),
        ExampleVariant(
          file: 'context_plus_value_notifier_bind_watch.dart',
          title: 'context_plus: watch() inside bind()',
          widget: context_plus_value_notifier_bind_watch.Example(),
        ),
      ],
    );
  }
}
