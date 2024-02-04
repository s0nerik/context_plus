import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../example.dart';

final _counterNotifier = Ref<ValueNotifier<int>>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _counterNotifier.bind(context, () => ValueNotifier(0));
    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return ExampleContainer(
      onTap: () => _counterNotifier.of(context).value += 1,
      child: CounterExample(
        counter: _counterNotifier.watch(context),
      ),
    );
  }
}
