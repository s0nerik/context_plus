import 'package:flutter/material.dart';

import '../../other/example.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _Child1(counter: counter);
  }
}

class _Child1 extends StatelessWidget {
  const _Child1({required this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    return _Child2(counter: counter);
  }
}

class _Child2 extends StatelessWidget {
  const _Child2({required this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      onTap: () =>
          context.findAncestorStateOfType<_ExampleState>()?.increment(),
      counter: counter,
    );
  }
}
