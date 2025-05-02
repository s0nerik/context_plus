import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = constraints.maxHeight * 2 / _colors.length;
        return Column(
          children: [
            _CurrentColor(
              scrollController: _scrollController,
              itemHeight: itemHeight,
            ),
            Expanded(
              child: _ColorsList(
                scrollController: _scrollController,
                itemHeight: itemHeight,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CurrentColor extends StatelessWidget {
  const _CurrentColor({
    required this.scrollController,
    required this.itemHeight,
  });

  final ScrollController scrollController;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        final scrollPosition = scrollController.positions.firstOrNull;
        final scrolledPixels = (scrollPosition?.pixels ?? 0).clamp(
          0,
          scrollPosition?.maxScrollExtent ?? 0,
        );
        final colorIndex = (scrolledPixels / itemHeight).floor();
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
      },
    );
  }
}

class _ColorsList extends StatelessWidget {
  const _ColorsList({required this.scrollController, required this.itemHeight});

  final ScrollController scrollController;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: _colors.length,
      itemBuilder:
          (context, index) =>
              _ColorItem(height: itemHeight, color: _colors[index]),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: color);
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
