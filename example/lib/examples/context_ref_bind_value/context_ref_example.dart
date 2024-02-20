import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../../other/example.dart';

final _counterRef = Ref<int>();

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    _counterRef.bindValue(context, _counter);
    return ExampleContainer(
      onTap: () => setState(() => _counter += 1),
      child: const _Child(),
    );
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      counter: _counterRef.of(context),
    );
  }
}
