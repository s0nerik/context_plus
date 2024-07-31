import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../../other/example.dart';

final _counter = Ref<int>();

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _counterValue = 0;

  void increment() {
    setState(() => _counterValue++);
  }

  @override
  Widget build(BuildContext context) {
    _counter.bindValue(context, _counterValue);
    return const _Child1();
  }
}

class _Child1 extends StatelessWidget {
  const _Child1();

  @override
  Widget build(BuildContext context) {
    return const _Child2();
  }
}

class _Child2 extends StatelessWidget {
  const _Child2();

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      onTap: () =>
          context.findAncestorStateOfType<_ExampleState>()!.increment(),
      counter: _counter.of(context),
    );
  }
}
