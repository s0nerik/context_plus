import 'package:flutter/material.dart';

import '../../other/example.dart';

class _Counter extends InheritedWidget {
  const _Counter({
    required this.counter,
    required super.child,
  });

  final int counter;

  static int of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Counter>()!.counter;

  @override
  bool updateShouldNotify(_Counter oldWidget) => counter != oldWidget.counter;
}

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
    return _Counter(
      counter: counter,
      child: const _Child1(),
    );
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
          context.findAncestorStateOfType<_ExampleState>()?.increment(),
      counter: _Counter.of(context),
    );
  }
}
