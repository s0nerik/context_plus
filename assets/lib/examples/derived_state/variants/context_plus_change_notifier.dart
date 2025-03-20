import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

class _State with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  int get counterSquared => _counter * _counter;

  void increment() {
    _counter += 1;
    notifyListeners();
  }
}

final _state = Ref<_State>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _state.bind(context, _State.new);
    return const Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    final counter = _state.watchOnly(context, (it) => it.counter);
    return Text('Counter: $counter');
  }
}

class _CounterSquared extends StatelessWidget {
  const _CounterSquared();

  @override
  Widget build(BuildContext context) {
    final counterSquared = _state.watchOnly(context, (it) => it.counterSquared);
    return Text('Counter²: $counterSquared');
  }
}

class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _state.of(context).increment,
      child: const Text('Increment'),
    );
  }
}
