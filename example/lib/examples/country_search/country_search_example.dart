import 'package:flutter/material.dart';

import '../../other/example.dart';

import 'variants/stateful_widget.dart' as stateful_widget;
import 'variants/stateful_and_inherited.dart' as stateful_and_inherited;
import 'variants/context_plus.dart' as context_plus;
import 'variants/context_plus_state_2.dart' as context_plus_state_2;
import 'variants/context_plus_state_1.dart' as context_plus_state_1;

class CountrySearchExample extends StatelessWidget {
  const CountrySearchExample({super.key});

  static const title = 'Live search example';
  static const urlPath = '/country_search_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      exampleDir: 'country_search',
      title: title,
      variants: [
        ExampleVariant(
          file: 'context_plus.dart',
          title: 'context_plus',
          widget: context_plus.Example(),
        ),
        ExampleVariant(
          file: 'context_plus_state_1.dart',
          title: 'context_plus (separate _State #1)',
          widget: context_plus_state_1.Example(),
        ),
        ExampleVariant(
          file: 'context_plus_state_2.dart',
          title: 'context_plus (separate _State #2)',
          widget: context_plus_state_2.Example(),
        ),
        ExampleVariant(
          file: 'stateful_widget.dart',
          title: 'StatefulWidget',
          widget: stateful_widget.Example(),
        ),
        ExampleVariant(
          file: 'stateful_and_inherited.dart',
          title: 'StatefulWidget + InheritedWidget',
          widget: stateful_and_inherited.Example(),
        ),
      ],
    );
  }
}
