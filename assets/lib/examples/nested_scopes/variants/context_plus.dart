import 'dart:math';

import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

final _globalScope = Ref<_Scope>();
final _childrenAmount = Ref<ValueNotifier<int>>();

final _childColor = Ref<Color>();
final _name = Ref<String>();
final _message = Ref<String>();
final _scope = Ref<_Scope>();

class _Scope {
  _Scope({
    required this.scopeName,
  });

  final String scopeName;

  final counter = ValueNotifier(0);

  void dispose() {
    debugPrint('_Scope($scopeName) was disposed');
    counter.dispose();
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _globalScope.bind(context, () => _Scope(scopeName: 'Global scope'));
    final childrenAmount =
        _childrenAmount.bind(context, () => ValueNotifier(3));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData.dark(),
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  color: Colors.white,
                ),
                child: _ChildWrapper(
                  depth: 1,
                  maxDepth: childrenAmount.watch(context),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => childrenAmount.value++,
              child: const Text('Add scope'),
            ),
            TextButton(
              onPressed: () => childrenAmount.value--,
              child: const Text('Remove scope'),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.paddingOf(context).bottom,
        ),
      ],
    );
  }
}

class _ChildWrapper extends StatefulWidget {
  const _ChildWrapper({
    required this.depth,
    required this.maxDepth,
    this.parentContext,
  });

  final int depth;
  final int maxDepth;
  final BuildContext? parentContext;

  @override
  State<_ChildWrapper> createState() => _ChildWrapperState();
}

class _ChildWrapperState extends State<_ChildWrapper> {
  static final scopeColors = [
    Colors.black,
    Colors.brown[900]!,
    Colors.green[900]!,
  ];

  late var _color = scopeColors[widget.depth % scopeColors.length];

  @override
  Widget build(BuildContext context) {
    _childColor.bindValue(context, _color);
    final name = _name.bindValue(context, 'Scope ${widget.depth}');
    _message.bindValue(context, 'Hello from $name');

    _scope.bind(context, () => _Scope(scopeName: name));

    final parentColor = widget.parentContext != null
        ? _childColor.of(widget.parentContext!)
        : null;

    return Stack(
      children: [
        _Child(
          parentColor: parentColor,
          child: widget.depth >= widget.maxDepth
              ? const SizedBox.shrink()
              : _ChildWrapper(
                  depth: widget.depth + 1,
                  maxDepth: widget.maxDepth,
                  parentContext: context,
                ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: TextButton(
            onPressed: () => setState(() {
              _color = Color.fromARGB(
                255,
                Random().nextInt(128),
                Random().nextInt(128),
                Random().nextInt(128),
              );
            }),
            child: const Text('Set random color'),
          ),
        ),
      ],
    );
  }
}

class _Child extends StatelessWidget {
  const _Child({
    required this.parentColor,
    this.child,
  });

  final Color? parentColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bgColor = _childColor.of(context);
    final scopeName = _name.of(context);
    final message = _message.of(context);
    final scope = _scope.of(context);

    final globalScope = _globalScope.of(context);

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Current scope: $scopeName'),
          Text('Message: $message'),
          Text('Counter: ${scope.counter.watch(context)}'),
          Text('Global counter: ${globalScope.counter.watch(context)}'),
          if (parentColor != null)
            Row(
              children: [
                const Text('Parent color: '),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: parentColor!,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          Row(
            children: [
              const Text('Increment: '),
              Expanded(
                child: TextButton(
                  onPressed: () => scope.counter.value++,
                  child: const Text('Local'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => globalScope.counter.value++,
                  child: const Text('Global'),
                ),
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
