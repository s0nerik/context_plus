import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/streams.dart';

enum BenchmarkDataType {
  valueListenable,
  future,
  stream,
  valueStream,
}

enum BenchmarkListenerType {
  contextWatch,
  streamBuilder,
}

class BenchmarkScreen extends StatefulWidget {
  BenchmarkScreen({
    super.key,
    this.sideCount = 15,
    this.availableSideCounts = const {10, 15, 20, 25, 30, 50},
    this.dataType = BenchmarkDataType.valueStream,
    this.listenerType = BenchmarkListenerType.contextWatch,
    this.runOnStart = true,
    this.showPerformanceOverlay = true,
  }) : assert(availableSideCounts.contains(sideCount));

  final int sideCount;
  final Set<int> availableSideCounts;
  final BenchmarkDataType dataType;
  final BenchmarkListenerType listenerType;
  final bool runOnStart;
  final bool showPerformanceOverlay;

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  var _gridKey = UniqueKey();
  late var _sideCount = widget.sideCount;
  late var _dataType = widget.dataType;
  late var _listenerType = widget.listenerType;
  late var _runBenchmark = widget.runOnStart;

  final _stream = Stream.periodic(const Duration(milliseconds: 1), (i) => i)
      .asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benchmark'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Grid rows/columns:'),
                  const SizedBox(width: 16),
                  DropdownButton<int>(
                    value: _sideCount,
                    onChanged: (value) => setState(() {
                      _sideCount = value!;
                      _gridKey = UniqueKey();
                    }),
                    items: [
                      for (final sideCount in widget.availableSideCounts)
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
                  const Text('Data type:'),
                  const SizedBox(width: 16),
                  DropdownButton<BenchmarkDataType>(
                    value: _dataType,
                    onChanged: (value) => setState(() {
                      _dataType = value!;
                      _gridKey = UniqueKey();
                    }),
                    items: const [
                      DropdownMenuItem(
                        value: BenchmarkDataType.stream,
                        child: Text('Stream'),
                      ),
                      DropdownMenuItem(
                        value: BenchmarkDataType.valueStream,
                        child: Text('ValueStream'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Listen using:'),
                  const SizedBox(width: 16),
                  DropdownButton<BenchmarkListenerType>(
                    value: _listenerType,
                    onChanged: (value) => setState(() {
                      _listenerType = value!;
                      _gridKey = UniqueKey();
                    }),
                    items: [
                      if (_dataType == BenchmarkDataType.stream ||
                          _dataType == BenchmarkDataType.valueStream) ...const [
                        DropdownMenuItem(
                          value: BenchmarkListenerType.contextWatch,
                          child: Text('Stream.watch(context)'),
                        ),
                        DropdownMenuItem(
                          value: BenchmarkListenerType.streamBuilder,
                          child: Text('StreamBuilder'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  'Total subscriptions: ${_sideCount * _sideCount * 2 + _sideCount * _sideCount}\n'
                  '${_sideCount * _sideCount} tiles, watching own 2 data sources\n'
                  '+ ${_sideCount * _sideCount} widgets watching a single data source',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  ElevatedButton(
                    key: const Key('start'),
                    onPressed: !_runBenchmark
                        ? () => setState(() {
                              _gridKey = UniqueKey();
                              _runBenchmark = true;
                            })
                        : null,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    key: const Key('stop'),
                    onPressed: _runBenchmark
                        ? () => setState(() {
                              _gridKey = UniqueKey();
                              _runBenchmark = false;
                            })
                        : null,
                    child: const Text('Stop'),
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
                child: _runBenchmark
                    ? GridView.builder(
                        key: _gridKey,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _sideCount,
                        ),
                        itemBuilder: (context, index) => _GridItem(
                          key: ValueKey(index),
                          index: index,
                          dataType: _dataType,
                          listenerType: _listenerType,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < _sideCount * _sideCount; i++)
              if (_listenerType == BenchmarkListenerType.contextWatch)
                Builder(
                  key: ValueKey(i),
                  builder: (context) {
                    _stream.watch(context);
                    return const SizedBox.shrink();
                  },
                )
              else if (_listenerType == BenchmarkListenerType.streamBuilder)
                StreamBuilder(
                  key: ValueKey(i),
                  stream: _stream,
                  builder: (context, _) => const SizedBox.shrink(),
                ),
            if (widget.showPerformanceOverlay)
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

class _GridItem extends StatelessWidget {
  const _GridItem({
    super.key,
    required this.index,
    required BenchmarkDataType dataType,
    required BenchmarkListenerType listenerType,
  })  : _dataType = dataType,
        _listenerType = listenerType;

  final int index;
  final BenchmarkDataType _dataType;
  final BenchmarkListenerType _listenerType;

  @override
  Widget build(BuildContext context) {
    if (_dataType == BenchmarkDataType.stream ||
        _dataType == BenchmarkDataType.valueStream) {
      return _StreamsProvider(
        key: ValueKey(index),
        useValueStream: _dataType == BenchmarkDataType.valueStream,
        initialDelay: Duration(milliseconds: 4 * index),
        delay: const Duration(milliseconds: 48),
        builder: (context, colorIndexStream, scaleIndexStream) {
          if (_listenerType == BenchmarkListenerType.contextWatch) {
            return ItemContextWatch(
              colorIndexStream: colorIndexStream,
              scaleIndexStream: scaleIndexStream,
            );
          }
          return ItemStreamBuilder(
            initialColorIndex: _dataType == BenchmarkDataType.valueStream
                ? (colorIndexStream as ValueStream<int>).value
                : null,
            colorIndexStream: colorIndexStream,
            initialScaleIndex: _dataType == BenchmarkDataType.valueStream
                ? (scaleIndexStream as ValueStream<int>).value
                : null,
            scaleIndexStream: scaleIndexStream,
          );
        },
      );
    }

    return const Placeholder();
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
