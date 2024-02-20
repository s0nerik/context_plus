import 'package:example/other/example.dart';
import 'package:flutter/material.dart';

class _CounterNotifier extends InheritedWidget {
  const _CounterNotifier({
    required this.counterNotifier,
    required super.child,
  });

  final ValueNotifier<int> counterNotifier;

  static ValueNotifier<int> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_CounterNotifier>()!
        .counterNotifier;
  }

  @override
  bool updateShouldNotify(_CounterNotifier oldWidget) {
    return oldWidget.counterNotifier != counterNotifier;
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final ValueNotifier<int> _counterNotifier;

  @override
  void initState() {
    super.initState();
    _counterNotifier = ValueNotifier(0);
  }

  @override
  void dispose() {
    _counterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CounterNotifier(
      counterNotifier: _counterNotifier,
      child: const _Child(),
    );
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return ExampleContainer(
      onTap: () => _CounterNotifier.of(context).value += 1,
      child: ValueListenableBuilder(
        valueListenable: _CounterNotifier.of(context),
        builder: (context, counter, _) => CounterExample(
          counter: counter,
        ),
      ),
    );
  }
}
