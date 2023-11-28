import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  var _gridKey = UniqueKey();
  var _sideCount = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benchmark'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text('Side count:'),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _sideCount,
                onChanged: (value) => setState(() {
                  _sideCount = value!;
                  _gridKey = UniqueKey();
                }),
                items: [
                  for (final sideCount in const [10, 15, 20, 30, 40, 50, 100])
                    DropdownMenuItem(
                      value: sideCount,
                      child: Text(sideCount.toString()),
                    ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            key: _gridKey,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _sideCount,
            ),
            itemBuilder: (context, index) => _StreamsProvider(
              key: ValueKey(index),
              initialDelay: Duration(milliseconds: 4 * index),
              delay: const Duration(milliseconds: 48),
              builder: (context, colorIndexStream, scaleIndexStream) {
                return StreamItemBuilder(
                  initialColorIndex: 0,
                  colorIndexStream: colorIndexStream,
                  initialScaleIndex: 0,
                  scaleIndexStream: scaleIndexStream,
                );
                // return StreamItem(stream: stream);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class StreamItem extends StatelessWidget {
  const StreamItem({
    super.key,
    required this.colorIndexStream,
    required this.scaleIndexStream,
  });

  final Stream<int> colorIndexStream;
  final Stream<int> scaleIndexStream;

  @override
  Widget build(BuildContext context) {
    return _build(
      colorIndexSnapshot: colorIndexStream.watch(context),
      scaleIndexSnapshot: scaleIndexStream.watch(context),
    );
  }
}

class StreamItemBuilder extends StatelessWidget {
  const StreamItemBuilder({
    super.key,
    required this.initialColorIndex,
    required this.colorIndexStream,
    required this.initialScaleIndex,
    required this.scaleIndexStream,
  });

  final int initialColorIndex;
  final Stream<int> colorIndexStream;
  final int initialScaleIndex;
  final Stream<int> scaleIndexStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialColorIndex,
      stream: colorIndexStream,
      builder: (context, colorIndexSnapshot) => StreamBuilder(
        initialData: initialScaleIndex,
        stream: scaleIndexStream,
        builder: (context, scaleIndexSnapshot) => _build(
          colorIndexSnapshot: colorIndexSnapshot,
          scaleIndexSnapshot: scaleIndexSnapshot,
        ),
      ),
    );
  }
}

class _StreamsProvider extends StatefulWidget {
  const _StreamsProvider({
    super.key,
    required this.builder,
    required this.initialDelay,
    required this.delay,
  });

  final Widget Function(
    BuildContext context,
    Stream<int> colorIndexStream,
    Stream<int> scaleIndexStream,
  ) builder;
  final Duration initialDelay;
  final Duration delay;

  @override
  State<_StreamsProvider> createState() => _StreamsProviderState();
}

class _StreamsProviderState extends State<_StreamsProvider> {
  late final colorIndexStream =
      Stream.fromFuture(Future.delayed(widget.initialDelay))
          .asyncExpand((_) => Stream<int>.periodic(widget.delay, (i) => i));
  late final scaleIndexStream =
      Stream.fromFuture(Future.delayed(widget.initialDelay))
          .asyncExpand((_) => Stream<int>.periodic(widget.delay, (i) => i));

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, colorIndexStream, scaleIndexStream);
  }
}

Widget _build({
  required AsyncSnapshot<int> colorIndexSnapshot,
  required AsyncSnapshot<int> scaleIndexSnapshot,
}) {
  final child = switch (colorIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final colorIndex) =>
      ColoredBox(color: _colors[colorIndex % _colors.length]),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: Colors.yellow),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
  };

  final scaledChild = switch (scaleIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final scaleIndex) =>
      Transform.scale(
        scale: _scales[scaleIndex % _scales.length],
        child: child,
      ),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: Colors.yellow),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
  };

  return scaledChild;
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

final _scales = _generateScales(0.5, 0.9, 32);
List<double> _generateScales(double startScale, double endScale, int steps) {
  List<double> scales = [];
  int halfSteps = steps ~/ 2; // integer division to get half the steps
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    scales.add(startScale + (endScale - startScale) * t);
  }
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    scales.add(endScale + (startScale - endScale) * t);
  }
  return scales;
}
