import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/streams.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  var _gridKey = UniqueKey();
  var _sideCount = 20;
  var _useStreamBuilder = false;
  var _useValueStream = true;

  @override
  Widget build(BuildContext context) {
    final totalSubscriptions = _sideCount * _sideCount * 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Benchmark'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Column(
            children: [
              Row(
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
                      for (final sideCount in const [10, 15, 20, 25, 30, 50])
                        DropdownMenuItem(
                          value: sideCount,
                          child: Text(sideCount.toString()),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Total subscriptions:'),
                  const SizedBox(width: 16),
                  Text(totalSubscriptions.toString()),
                  const SizedBox(width: 16),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Subscribe using:'),
                  const SizedBox(width: 16),
                  DropdownButton<bool>(
                    value: _useStreamBuilder,
                    onChanged: (value) => setState(() {
                      _useStreamBuilder = value!;
                      _gridKey = UniqueKey();
                    }),
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text('Stream.watch(context)'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('StreamBuilder'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Stream type:'),
                  const SizedBox(width: 16),
                  DropdownButton<bool>(
                    value: _useValueStream,
                    onChanged: (value) => setState(() {
                      _useValueStream = value!;
                      _gridKey = UniqueKey();
                    }),
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text('Stream'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('ValueStream'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  key: _gridKey,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _sideCount,
                  ),
                  itemBuilder: (context, index) => _StreamsProvider(
                    key: ValueKey(index),
                    useValueStream: _useValueStream,
                    initialDelay: Duration(milliseconds: 4 * index),
                    delay: const Duration(milliseconds: 48),
                    builder: (context, colorIndexStream, scaleIndexStream) {
                      if (!_useStreamBuilder) {
                        return ItemContextWatch(
                          colorIndexStream: colorIndexStream,
                          scaleIndexStream: scaleIndexStream,
                        );
                      }
                      return ItemStreamBuilder(
                        initialColorIndex: _useValueStream
                            ? (colorIndexStream as ValueStream<int>).value
                            : null,
                        colorIndexStream: colorIndexStream,
                        initialScaleIndex: _useValueStream
                            ? (scaleIndexStream as ValueStream<int>).value
                            : null,
                        scaleIndexStream: scaleIndexStream,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            PerformanceOverlay(
              optionsMask: 1 <<
                      PerformanceOverlayOption
                          .displayRasterizerStatistics.index |
                  1 << PerformanceOverlayOption.displayEngineStatistics.index,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemContextWatch extends StatelessWidget {
  const ItemContextWatch({
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

class ItemStreamBuilder extends StatelessWidget {
  const ItemStreamBuilder({
    super.key,
    required this.initialColorIndex,
    required this.colorIndexStream,
    required this.initialScaleIndex,
    required this.scaleIndexStream,
  });

  final int? initialColorIndex;
  final Stream<int> colorIndexStream;
  final int? initialScaleIndex;
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
    required this.useValueStream,
  });

  final Widget Function(
    BuildContext context,
    Stream<int> colorIndexStream,
    Stream<int> scaleIndexStream,
  ) builder;
  final Duration initialDelay;
  final Duration delay;
  final bool useValueStream;

  @override
  State<_StreamsProvider> createState() => _StreamsProviderState();
}

class _StreamsProviderState extends State<_StreamsProvider> {
  late Stream<int> colorIndexStream;
  late Stream<int> scaleIndexStream;

  @override
  void initState() {
    super.initState();
    final initialDelay = widget.initialDelay;
    final delay = widget.delay;
    colorIndexStream = Stream.fromFuture(Future.delayed(initialDelay))
        .asyncExpand((_) => Stream<int>.periodic(delay, (i) => i));
    scaleIndexStream = Stream.fromFuture(Future.delayed(initialDelay))
        .asyncExpand((_) => Stream<int>.periodic(delay, (i) => i));
    if (widget.useValueStream) {
      colorIndexStream = colorIndexStream.shareValueSeeded(0);
      scaleIndexStream = scaleIndexStream.shareValueSeeded(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, colorIndexStream, scaleIndexStream);
  }
}

Widget _build({
  required AsyncSnapshot<int> colorIndexSnapshot,
  required AsyncSnapshot<int> scaleIndexSnapshot,
}) {
  const loadingColor = Color(0xFFFFFACA);

  final child = switch (colorIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final colorIndex) =>
      ColoredBox(color: _colors[colorIndex % _colors.length]),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: loadingColor),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
  };

  final scaledChild = switch (scaleIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final scaleIndex) =>
      Transform.scale(
        scale: _scales[scaleIndex % _scales.length],
        child: child,
      ),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: loadingColor),
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
