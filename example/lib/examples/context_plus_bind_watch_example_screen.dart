import 'package:flutter/material.dart';

import '../example.dart';
import 'context_plus_bind_watch/context_plus_example.dart' as context_plus;

class ContextPlusBindWatchExampleScreen extends StatelessWidget {
  const ContextPlusBindWatchExampleScreen({super.key});

  static const title = 'Ref.bind() + Ref.watch()';
  static const urlPath = '/context_plus_bind_watch_example';

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: title,
      variants: [
        ExampleVariant(
          title: 'context_plus',
          filePath: 'context_plus_bind_watch/context_plus_example.dart',
          widget: context_plus.Example(),
        ),
      ],
    );
  }
}
