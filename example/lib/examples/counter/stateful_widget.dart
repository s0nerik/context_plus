import 'package:flutter/material.dart';

import '../../other/example.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var counter = 0;

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      onTap: () => setState(() => counter += 1),
      counter: counter,
    );
  }
}
