import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

final _counter = Ref<ValueNotifier<int>>();
final _counterSquared = Ref<_Squared>();

class _Squared extends ValueNotifier<int> {
  _Squared(super.value);

  @override
  void dispose() {
    debugPrint('dispose $_counterSquared');
    super.dispose();
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _counter.bind(context, (context) => ValueNotifier(0));
    _counterSquared.bind(
      context,
      (context) {
        final counter = _counter.watch(context);
        return _Squared(counter);
      },
    );
    return const Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Counter(),
        SizedBox(height: 16),
        _CounterSquared(),
        SizedBox(height: 16),
        _IncrementButton(),
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter();

  @override
  Widget build(BuildContext context) {
    final counter = _counter.watch(context);
    return Text('Counter: $counter');
  }
}

class _CounterSquared extends StatelessWidget {
  const _CounterSquared();

  @override
  Widget build(BuildContext context) {
    final counterSquared = _counterSquared.watch(context);
    return Text('Counter²: $counterSquared');
  }
}

class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _counter.of(context).value += 1,
      child: const Text('Increment'),
    );
  }
}
