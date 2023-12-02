import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';

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
  const BenchmarkScreen({
    super.key,
    this.singleObservableSubscriptionsCount = 100,
    this.singleObservableSubscriptionCountOptions = const {0, 1, 10, 100, 1000},
    this.tilesCount = 500,
    this.tileCountOptions = const {0, 1, 10, 100, 500, 1000, 10000, 20000},
    this.observablesPerTile = 2,
    this.observablesPerTileOptions = const {0, 1, 2, 3, 5, 10, 20, 50, 100},
    this.dataType = BenchmarkDataType.valueStream,
    this.listenerType = BenchmarkListenerType.contextWatch,
    this.runOnStart = true,
    this.showPerformanceOverlay = true,
    this.visualize = true,
  });

  final int singleObservableSubscriptionsCount;
  final Set<int> singleObservableSubscriptionCountOptions;

  final int tilesCount;
  final Set<int> tileCountOptions;

  final int observablesPerTile;
  final Set<int> observablesPerTileOptions;

  final BenchmarkDataType dataType;
  final BenchmarkListenerType listenerType;

  final bool runOnStart;
  final bool showPerformanceOverlay;
  final bool visualize;

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  var _gridKey = UniqueKey();

  late var _singleObservableSubscriptionsCount =
      widget.singleObservableSubscriptionsCount;
  late var _tilesCount = widget.tilesCount;
  late var _observablesPerTile = widget.observablesPerTile;

  late var _dataType = widget.dataType;
  late var _listenerType = widget.listenerType;
  late var _runBenchmark = widget.runOnStart;

  late var _visualize = widget.visualize;

  final _streamController = StreamController<int>.broadcast();
  late final Stream<int> _stream = _streamController.stream;

  @override
  void initState() {
    super.initState();
    _publishToStreamWhileMounted();
  }

  Future<void> _publishToStreamWhileMounted() async {
    var index = 0;
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1));
      if (!mounted) {
        break;
      }
      _streamController.add(index);
      index++;
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benchmark')),
      body: Container(
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: 16 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 16,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                _buildSingleObservableSubscriptionsSelector(),
                _buildTilesCountSelector(),
                _buildObservablesPerTileSelector(),
                _buildDataTypeSelector(),
                _buildListenerSelector(),
              ],
            ),
            _buildTotalSubscriptionsInfo(),
            _buildControlButtons(),
            const SizedBox(height: 16),
            Expanded(
              child: _runBenchmark ? _buildGrid() : const SizedBox.shrink(),
            ),
            if (_runBenchmark)
              for (var i = 0; i < _singleObservableSubscriptionsCount; i++)
                _buildSingleObservableObserver(i),
            const SizedBox(height: 32),
            if (widget.showPerformanceOverlay) _buildPerformanceOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int tileSize = 24;
        var tilesPerRow = constraints.maxWidth ~/ tileSize;
        var rowsCount = _tilesCount ~/ tilesPerRow;
        var rowsHeight = rowsCount * tileSize;
        while (rowsHeight > constraints.maxHeight) {
          tileSize -= 1;
          if (tileSize == 0) {
            break;
          }
          tilesPerRow = constraints.maxWidth ~/ tileSize;
          rowsCount = _tilesCount ~/ tilesPerRow;
          rowsHeight = rowsCount * tileSize;
        }

        return Wrap(
          key: _gridKey,
          children: [
            for (var i = 0; i < _tilesCount; i++) _buildTile(i, tileSize),
          ],
        );
      },
    );
  }

  Widget _buildSingleObservableSubscriptionsSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Single observable subscriptions:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          isDense: true,
          value: _singleObservableSubscriptionsCount,
          onChanged: (value) => setState(() {
            _singleObservableSubscriptionsCount = value!;
            _gridKey = UniqueKey();
          }),
          items: [
            for (final singleObservableSubscriptionsCount
                in widget.singleObservableSubscriptionCountOptions)
              DropdownMenuItem(
                value: singleObservableSubscriptionsCount,
                child: Text(singleObservableSubscriptionsCount.toString()),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTilesCountSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Tiles count:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          isDense: true,
          value: _tilesCount,
          onChanged: (value) => setState(() {
            _tilesCount = value!;
            _gridKey = UniqueKey();
          }),
          items: [
            for (final tilesCount in widget.tileCountOptions)
              DropdownMenuItem(
                value: tilesCount,
                child: Text(tilesCount.toString()),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildObservablesPerTileSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Observables per tile:'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          isDense: true,
          value: _observablesPerTile,
          onChanged: (value) => setState(() {
            _observablesPerTile = value!;
            _gridKey = UniqueKey();
          }),
          items: [
            for (final observablesPerTile in widget.observablesPerTileOptions)
              DropdownMenuItem(
                value: observablesPerTile,
                child: Text(observablesPerTile.toString()),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTypeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Data type:'),
        const SizedBox(width: 8),
        DropdownButton<BenchmarkDataType>(
          isDense: true,
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
      ],
    );
  }

  Widget _buildListenerSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Listen using:'),
        const SizedBox(width: 8),
        DropdownButton<BenchmarkListenerType>(
          isDense: true,
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
      ],
    );
  }

  Widget _buildTotalSubscriptionsInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Total\u{00A0}subscriptions:\u{00A0}${_singleObservableSubscriptionsCount + _tilesCount * _observablesPerTile}\n'
        '$_singleObservableSubscriptionsCount\u{00A0}single\u{00A0}observable\u{00A0}subscriptions '
        '+ $_tilesCount\u{00A0}tiles\u{00A0}*\u{00A0}$_observablesPerTile\u{00A0}observables\u{00A0}',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton(
          key: const Key('start'),
          style: OutlinedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: !_runBenchmark
              ? () => setState(() {
                    _gridKey = UniqueKey();
                    _runBenchmark = true;
                  })
              : null,
          child: const Text('Start'),
        ),
        OutlinedButton(
          key: const Key('stop'),
          style: OutlinedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: _runBenchmark
              ? () => setState(() {
                    _gridKey = UniqueKey();
                    _runBenchmark = false;
                  })
              : null,
          child: const Text('Stop'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _visualize,
              onChanged: (value) => setState(() {
                _visualize = value!;
                _gridKey = UniqueKey();
              }),
            ),
            const Text('Visualize'),
          ],
        ),
      ],
    );
  }

  Widget _buildTile(int i, int tileSize) {
    return SizedBox(
      key: ValueKey(i),
      width: tileSize.toDouble(),
      height: tileSize.toDouble(),
      child: _Tile(
        key: ValueKey('tile$i'),
        index: i,
        dataType: _dataType,
        listenerType: _listenerType,
        visualize: _visualize,
        observablesPerTile: _observablesPerTile,
      ),
    );
  }

  Widget _buildSingleObservableObserver(int index) {
    return switch (_listenerType) {
      BenchmarkListenerType.contextWatch => Builder(
          key: ValueKey(index),
          builder: (context) {
            _stream.watch(context);
            return const SizedBox.shrink();
          },
        ),
      BenchmarkListenerType.streamBuilder => StreamBuilder(
          key: ValueKey(index),
          stream: _stream,
          builder: (context, _) => const SizedBox.shrink(),
        ),
    };
  }

  Widget _buildPerformanceOverlay() {
    return SizedBox(
      height: 36,
      child: PerformanceOverlay(
        optionsMask:
            1 << PerformanceOverlayOption.displayRasterizerStatistics.index |
                1 << PerformanceOverlayOption.displayEngineStatistics.index,
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    super.key,
    required this.index,
    required this.dataType,
    required this.listenerType,
    required this.observablesPerTile,
    required this.visualize,
  });

  final int index;
  final BenchmarkDataType dataType;
  final BenchmarkListenerType listenerType;
  final int observablesPerTile;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    if (dataType == BenchmarkDataType.stream ||
        dataType == BenchmarkDataType.valueStream) {
      return _StreamsProvider(
        key: ValueKey(index),
        observablesPerTile: observablesPerTile,
        useValueStream: dataType == BenchmarkDataType.valueStream,
        initialDelay: Duration(milliseconds: 4 * index),
        delay: const Duration(milliseconds: 48),
        builder: (context, colorIndexStream, scaleIndexStream, otherStreams) {
          if (listenerType == BenchmarkListenerType.contextWatch) {
            return ItemContextWatch(
              colorIndexStream: colorIndexStream,
              scaleIndexStream: scaleIndexStream,
              otherStreams: otherStreams,
              visualize: visualize,
            );
          }
          return ItemStreamBuilder(
            initialColorIndex: dataType == BenchmarkDataType.valueStream
                ? (colorIndexStream as ValueStream<int>?)?.value
                : null,
            colorIndexStream: colorIndexStream,
            initialScaleIndex: dataType == BenchmarkDataType.valueStream
                ? (scaleIndexStream as ValueStream<int>?)?.value
                : null,
            scaleIndexStream: scaleIndexStream,
            otherStreams: otherStreams,
            visualize: visualize,
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
    required this.otherStreams,
    required this.visualize,
  });

  final Stream<int>? colorIndexStream;
  final Stream<int>? scaleIndexStream;
  final List<Stream<int>> otherStreams;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    for (final otherStream in otherStreams) {
      otherStream.watch(context);
    }
    return _build(
      colorIndexSnapshot: colorIndexStream?.watch(context),
      scaleIndexSnapshot: scaleIndexStream?.watch(context),
      visualize: visualize,
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
    required this.otherStreams,
    required this.visualize,
  });

  final int? initialColorIndex;
  final Stream<int>? colorIndexStream;
  final int? initialScaleIndex;
  final Stream<int>? scaleIndexStream;
  final List<Stream<int>> otherStreams;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (colorIndexStream != null && scaleIndexStream != null) {
      child = StreamBuilder(
        initialData: initialColorIndex,
        stream: colorIndexStream,
        builder: (context, colorIndexSnapshot) => StreamBuilder(
          initialData: initialScaleIndex,
          stream: scaleIndexStream,
          builder: (context, scaleIndexSnapshot) => _build(
            colorIndexSnapshot: colorIndexSnapshot,
            scaleIndexSnapshot: scaleIndexSnapshot,
            visualize: visualize,
          ),
        ),
      );
    } else if (colorIndexStream != null) {
      child = StreamBuilder(
        initialData: initialColorIndex,
        stream: colorIndexStream,
        builder: (context, colorIndexSnapshot) => _build(
          colorIndexSnapshot: colorIndexSnapshot,
          scaleIndexSnapshot: null,
          visualize: visualize,
        ),
      );
    } else if (scaleIndexStream != null) {
      child = StreamBuilder(
        initialData: initialScaleIndex,
        stream: scaleIndexStream,
        builder: (context, scaleIndexSnapshot) => _build(
          colorIndexSnapshot: null,
          scaleIndexSnapshot: scaleIndexSnapshot,
          visualize: visualize,
        ),
      );
    } else {
      child = _build(
        colorIndexSnapshot: null,
        scaleIndexSnapshot: null,
        visualize: visualize,
      );
    }

    for (final otherStream in otherStreams) {
      final prevChild = child;
      child = StreamBuilder(
        stream: otherStream,
        builder: (context, _) => prevChild,
      );
    }
    return child;
  }
}

class _StreamsProvider extends StatefulWidget {
  const _StreamsProvider({
    super.key,
    required this.builder,
    required this.initialDelay,
    required this.delay,
    required this.useValueStream,
    required this.observablesPerTile,
  });

  final Widget Function(
    BuildContext context,
    Stream<int>? colorIndexStream,
    Stream<int>? scaleIndexStream,
    List<Stream<int>> otherStreams,
  ) builder;
  final Duration initialDelay;
  final Duration delay;
  final bool useValueStream;
  final int observablesPerTile;

  @override
  State<_StreamsProvider> createState() => _StreamsProviderState();
}

class _StreamsProviderState extends State<_StreamsProvider> {
  StreamController<int>? colorIndexController;
  StreamController<int>? scaleIndexController;
  List<StreamController<int>> otherStreamControllers = [];

  Stream<int>? colorIndexStream;
  Stream<int>? scaleIndexStream;
  List<Stream<int>> otherStreams = [];

  @override
  void initState() {
    super.initState();
    if (widget.observablesPerTile > 0) {
      colorIndexController = widget.useValueStream
          ? BehaviorSubject<int>.seeded(0)
          : StreamController<int>();
      colorIndexStream = colorIndexController!.stream;
    }
    if (widget.observablesPerTile > 1) {
      scaleIndexController = widget.useValueStream
          ? BehaviorSubject<int>.seeded(0)
          : StreamController<int>();
      scaleIndexStream = scaleIndexController!.stream;
    }
    for (var i = 2; i < widget.observablesPerTile; i++) {
      otherStreamControllers.add(widget.useValueStream
          ? BehaviorSubject<int>.seeded(0)
          : StreamController<int>());
      otherStreams.add(otherStreamControllers.last.stream);
    }
    _notifyValuesWhileMounted();
  }

  @override
  void dispose() {
    colorIndexController?.close();
    scaleIndexController?.close();
    for (final otherStreamController in otherStreamControllers) {
      otherStreamController.close();
    }
    super.dispose();
  }

  Future<void> _notifyValuesWhileMounted() async {
    await Future.delayed(widget.initialDelay);
    var index = 0;
    while (mounted) {
      await Future.delayed(widget.delay);
      if (!mounted) {
        break;
      }
      if (widget.observablesPerTile > 0) {
        colorIndexController?.add(index);
      }
      if (widget.observablesPerTile > 1) {
        scaleIndexController?.add(index);
      }
      for (var i = 2; i < widget.observablesPerTile; i++) {
        otherStreamControllers[i - 2].add(index);
      }
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, colorIndexStream, scaleIndexStream, otherStreams);
  }
}

Widget _build({
  required AsyncSnapshot<int>? colorIndexSnapshot,
  required AsyncSnapshot<int>? scaleIndexSnapshot,
  required bool visualize,
}) {
  if (!visualize) {
    return const SizedBox.shrink();
  }

  const loadingColor = Color(0xFFFFFACA);

  final child = switch (colorIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final colorIndex) =>
      ColoredBox(color: _colors[colorIndex % _colors.length]),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: loadingColor),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
    null => ColoredBox(color: Colors.grey.shade300),
  };

  final scaledChild = switch (scaleIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final scaleIndex) =>
      Transform.scale(
        scale: _scales[scaleIndex % _scales.length],
        child: child,
      ),
    AsyncSnapshot(hasError: false) => child,
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
    null => child,
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
