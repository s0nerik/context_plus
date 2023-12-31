import 'package:context_ref/context_ref.dart';
import 'package:context_use/context_use.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';

import '../example.dart';

final _counterNotifier = Ref<ValueNotifier<int>>();

class BindExample extends StatelessWidget {
  const BindExample({super.key});

  @override
  Widget build(BuildContext context) {
    final counterNotifier = context.use(() => ValueNotifier(0));
    _counterNotifier.bind(context, counterNotifier);
    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    return CounterExample(
      counter: _counterNotifier.of(context).watch(context),
      onIncrement: () => _counterNotifier.of(context).value += 1,
    );
  }
}
