import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

class _State with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  set counter(int value) {
    _counter = value;
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
      children: [
        _Counter(),
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
    final counter = _state.watchOnly(context, (state) => state.counter);
    return Text(counter.toString());
  }
}

class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _state.of(context).counter += 1,
      child: const Text('Increment'),
    );
  }
}
