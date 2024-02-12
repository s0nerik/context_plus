import 'package:flutter/material.dart';

import '../../example.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final _counterNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _counterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleContainer(
      onTap: () => _counterNotifier.value += 1,
      child: ValueListenableBuilder(
        valueListenable: _counterNotifier,
        builder: (context, counter, _) => CounterExample(
          counter: counter,
        ),
      ),
    );
  }
}
