import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../../other/example.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.use(() => ValueNotifier(0));
    return CounterExample(
      onTap: () => counter.value += 1,
      counter: counter.watch(context),
    );
  }
}
