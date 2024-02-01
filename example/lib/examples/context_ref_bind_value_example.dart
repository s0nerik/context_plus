import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../example.dart';

final _counterRef = Ref<int>();

class BindValueExample extends StatefulWidget {
  const BindValueExample({super.key});

  @override
  State<BindValueExample> createState() => _BindValueExampleState();
}

class _BindValueExampleState extends State<BindValueExample> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    _counterRef.bindValue(context, _counter);
    return Stack(
      children: [
        const _Child(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _counter += 1),
        ),
      ],
    );
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      counter: _counterRef.of(context),
      onIncrement: () {},
    );
  }
}
