import 'package:flutter/material.dart';

import '../../other/example.dart';

class _Counter extends InheritedWidget {
  const _Counter({
    required this.counter,
    required super.child,
  });

  final int counter;

  static int of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_Counter>()!.counter;
  }

  @override
  bool updateShouldNotify(_Counter oldWidget) {
    return oldWidget.counter != counter;
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    return _Counter(
      counter: _counter,
      child: ExampleContainer(
        onTap: () => setState(() => _counter += 1),
        child: const _Child(),
      ),
    );
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      counter: _Counter.of(context),
    );
  }
}
