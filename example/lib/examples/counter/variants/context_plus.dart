import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../../other/example.dart';

final _counter = Ref<ValueNotifier<int>>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _counter.bind(context, () => ValueNotifier(0));
    return CounterExample(
      onTap: () => _counter.of(context).value += 1,
      counter: _counter.watch(context),
    );
  }
}
