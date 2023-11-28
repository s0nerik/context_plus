import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('context_watch'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(64),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 32,
            ),
            itemBuilder: (context, index) => _StreamProvider(
              key: ValueKey(index),
              initialDelay: Duration(milliseconds: 4 * index),
              delay: const Duration(milliseconds: 48),
              builder: (context, stream) {
                return StreamItemBuilder(stream: stream);
                // return StreamItem(stream: stream);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StreamProvider extends StatefulWidget {
  const _StreamProvider({
    super.key,
    required this.builder,
    required this.initialDelay,
    required this.delay,
  });

  final Widget Function(BuildContext context, Stream<int> stream) builder;
  final Duration initialDelay;
  final Duration delay;

  @override
  State<_StreamProvider> createState() => _StreamProviderState();
}

class _StreamProviderState extends State<_StreamProvider> {
  late final stream = Stream.fromFuture(Future.delayed(widget.initialDelay))
      .asyncExpand((_) => Stream<int>.periodic(widget.delay, (i) => i));

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, stream);
  }
}

class StreamItem extends StatelessWidget {
  const StreamItem({
    super.key,
    required this.stream,
  });

  final Stream<int> stream;

  @override
  Widget build(BuildContext context) {
    return _buildAsyncSnapshot(stream.watch(context));
  }
}

class StreamItemBuilder extends StatelessWidget {
  const StreamItemBuilder({
    super.key,
    this.initialData = 0,
    required this.stream,
  });

  final int initialData;
  final Stream<int> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) => _buildAsyncSnapshot(snapshot),
    );
  }
}

Widget _buildAsyncSnapshot(AsyncSnapshot<int> colorIndexSnapshot) {
  return switch (colorIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final colorIndex) =>
      ColoredBox(color: _colors[colorIndex % _colors.length]),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: Colors.yellow),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
  };
}

final _colors = _generateGradient(Colors.white, Colors.grey.shade400, 32);
List<Color> _generateGradient(Color startColor, Color endColor, int steps) {
  List<Color> gradientColors = [];
  int halfSteps = steps ~/ 2; // integer division to get half the steps
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    gradientColors.add(Color.lerp(startColor, endColor, t)!);
  }
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    gradientColors.add(Color.lerp(endColor, startColor, t)!);
  }
  return gradientColors;
}
