import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

final _scrollController = Ref<ScrollController>();
final _itemHeight = Ref<double>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _scrollController.bind(context, ScrollController.new);
    return LayoutBuilder(
      builder: (context, constraints) {
        _itemHeight.bindValue(
            context, constraints.maxHeight * 2 / _colors.length);
        return const Column(
          children: [
            _CurrentColor(),
            Expanded(
              child: _ColorsList(),
            ),
          ],
        );
      },
    );
  }
}

class _CurrentColor extends StatelessWidget {
  const _CurrentColor();

  @override
  Widget build(BuildContext context) {
    final scrollController = _scrollController.of(context);
    final scrollPosition =
        (scrollController..watch(context)).positions.firstOrNull;
    final scrolledPixels = (scrollPosition?.pixels ?? 0)
        .clamp(0, scrollPosition?.maxScrollExtent ?? 0);
    final colorIndex = (scrolledPixels / _itemHeight.of(context)).floor();
    final color = _colors[colorIndex];
    return Container(
      height: 100,
      color: color,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        color.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ColorsList extends StatelessWidget {
  const _ColorsList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController.of(context),
      itemCount: _colors.length,
      itemBuilder: (context, index) => _ColorItem(color: _colors[index]),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _itemHeight.of(context),
      color: color,
    );
  }
}

const _colors = [
  Color(0xFFf44336),
  Color(0xFFe91e63),
  Color(0xFF9c27b0),
  Color(0xFF673ab7),
  Color(0xFF3f51b5),
  Color(0xFF2196f3),
  Color(0xFF03a9f4),
  Color(0xFF00bcd4),
  Color(0xFF009688),
  Color(0xFF4caf50),
  Color(0xFF8bc34a),
  Color(0xFFcddc39),
  Color(0xFFffeb3b),
  Color(0xFFffc107),
  Color(0xFFff9800),
  Color(0xFFff5722),
];
