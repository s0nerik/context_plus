import 'package:flutter/material.dart';
import 'package:performance/performance.dart';

import 'common/observable_listener_types.dart';
import 'common/observer.dart';
import 'common/publisher.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({
    super.key,
    this.singleObservableSubscriptionsCount = 100,
    this.singleObservableNotifyInterval = const Duration(milliseconds: 1),
    this.singleObservableSubscriptionCountOptions = const {
      0,
      1,
      10,
      100,
      200,
      500,
      750,
      1000,
    },
    this.tilesCount = 500,
    this.tileCountOptions = const {
      0,
      1,
      10,
      100,
      200,
      500,
      750,
      1000,
      5000,
      10000,
      20000,
    },
    this.observablesPerTile = 2,
    this.observablesPerTileOptions = const {0, 1, 2, 3, 5, 10, 20, 50, 100},
    this.observableType = ObservableType.valueStream,
    this.listenerType = ListenerType.contextWatch,
    this.runOnStart = false,
    this.showPerformanceOverlay = true,
    this.visualize = true,
    this.tileObservableNotifyInterval = const Duration(milliseconds: 48),
  });

  final int singleObservableSubscriptionsCount;
  final Duration singleObservableNotifyInterval;
  final Set<int> singleObservableSubscriptionCountOptions;

  final int tilesCount;
  final Set<int> tileCountOptions;

  final int observablesPerTile;
  final Set<int> observablesPerTileOptions;

  final ObservableType observableType;
  final ListenerType listenerType;

  final bool runOnStart;
  final bool showPerformanceOverlay;
  final bool visualize;

  final Duration tileObservableNotifyInterval;

  static const title = 'Value observing benchmark';
  static const description =
      'Compare performance of different value observing mechanisms/libraries.';
  static const tags = ['ValueListenable.watch()', 'Stream.watch()'];

  static const urlPath = '/context_watch_benchmark';

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  var _bodyKey = UniqueKey();

  late var _singleObservableSubscriptionsCount =
      widget.singleObservableSubscriptionsCount;
  late var _tilesCount = widget.tilesCount;
  late var _observablesPerTile = widget.observablesPerTile;

  late var _observableType = widget.observableType;
  late var _listenerType = widget.listenerType;
  late var _runBenchmark = widget.runOnStart;

  late var _visualize = widget.visualize;

  late Publisher _commonPublisher;

  @override
  void initState() {
    super.initState();
    _commonPublisher = Publisher(
      observableType: _observableType,
      observableCount: 1,
      initialDelay: Duration.zero,
      interval: widget.tileObservableNotifyInterval,
    )..publishWhileMounted(context);
  }

  @override
  void dispose() {
    _commonPublisher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(BenchmarkScreen.title)),
      body: Container(
        key: _bodyKey,
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
                _buildObservableTypeSelector(),
                _buildListenerSelector(),
              ],
            ),
            const SizedBox(height: 8),
            _buildTotalSubscriptionsInfo(),
            const SizedBox(height: 8),
            _buildControlButtons(),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _runBenchmark
                      ? _buildGrid()
                      : const Center(
                        child: Text('Press "Start" to run benchmark'),
                      ),
            ),
            if (_runBenchmark)
              for (var i = 0; i < _singleObservableSubscriptionsCount; i++)
                Observer(
                  key: ValueKey(i),
                  publisher: _commonPublisher,
                  listenerType: _listenerType,
                  visualize: false,
                ),
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
          onChanged:
              (value) => setState(() {
                _singleObservableSubscriptionsCount = value!;
                _bodyKey = UniqueKey();
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
          onChanged:
              (value) => setState(() {
                _tilesCount = value!;
                _bodyKey = UniqueKey();
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
          onChanged:
              (value) => setState(() {
                _observablesPerTile = value!;
                _bodyKey = UniqueKey();
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

  Widget _buildObservableTypeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Data type:'),
        const SizedBox(width: 8),
        DropdownButton<ObservableType>(
          isDense: true,
          value: _observableType,
          onChanged:
              (value) => setState(() {
                _listenerType = value!.listenerTypes.first;
                _observableType = value;
                _commonPublisher.dispose();
                _commonPublisher = Publisher(
                  observableType: _observableType,
                  observableCount: _singleObservableSubscriptionsCount,
                  initialDelay: Duration.zero,
                  interval: widget.tileObservableNotifyInterval,
                )..publishWhileMounted(context);
                _bodyKey = UniqueKey();
              }),
          items: [
            for (final observableType in ObservableType.values)
              DropdownMenuItem(
                value: observableType,
                child: Text(observableType.displayName),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildListenerSelector() {
    return Wrap(
      children: [
        const Text('Listen using:'),
        const SizedBox(width: 8),
        DropdownButton<ListenerType>(
          isDense: true,
          value: _listenerType,
          onChanged:
              (value) => setState(() {
                _listenerType = value!;
                _bodyKey = UniqueKey();
              }),
          items: [
            for (final listenerType in _observableType.listenerTypes)
              DropdownMenuItem(
                value: listenerType,
                child: Text(listenerType.displayName(_observableType)),
              ),
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
          onPressed:
              !_runBenchmark
                  ? () => setState(() {
                    _bodyKey = UniqueKey();
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
          onPressed:
              _runBenchmark
                  ? () => setState(() {
                    _bodyKey = UniqueKey();
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
              onChanged:
                  (value) => setState(() {
                    _visualize = value!;
                    _bodyKey = UniqueKey();
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
        key: ValueKey('tile_$i'),
        index: i,
        observableType: _observableType,
        listenerType: _listenerType,
        visualize: _visualize,
        observablesPerTile: _observablesPerTile,
        observableNotifyInterval: widget.tileObservableNotifyInterval,
      ),
    );
  }

  Widget _buildPerformanceOverlay() {
    return const SizedBox(
      height: 36,
      child: CustomPerformanceOverlay(
        alignment: Alignment.center,
        child: SizedBox(),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    super.key,
    required this.index,
    required this.observableType,
    required this.listenerType,
    required this.observablesPerTile,
    required this.visualize,
    required this.observableNotifyInterval,
  });

  final int index;
  final ObservableType observableType;
  final ListenerType listenerType;
  final int observablesPerTile;
  final bool visualize;
  final Duration observableNotifyInterval;

  @override
  Widget build(BuildContext context) {
    return _PublisherProvider(
      key: ValueKey(index),
      initialDelay:
          visualize ? Duration(milliseconds: 4 * index) : Duration.zero,
      observableNotifyInterval: observableNotifyInterval,
      observableType: observableType,
      observablesPerTile: observablesPerTile,
      builder:
          (context, publisher) => Observer(
            publisher: publisher,
            listenerType: listenerType,
            visualize: visualize,
          ),
    );
  }
}

class _PublisherProvider extends StatefulWidget {
  const _PublisherProvider({
    super.key,
    required this.initialDelay,
    required this.observableNotifyInterval,
    required this.observableType,
    required this.observablesPerTile,
    required this.builder,
  });

  final Duration initialDelay;
  final Duration observableNotifyInterval;
  final ObservableType observableType;
  final int observablesPerTile;
  final Widget Function(BuildContext context, Publisher publisher) builder;

  @override
  State<_PublisherProvider> createState() => _PublisherProviderState();
}

class _PublisherProviderState extends State<_PublisherProvider> {
  late final publisher = Publisher(
    observableType: widget.observableType,
    observableCount: widget.observablesPerTile,
    initialDelay: widget.initialDelay,
    interval: widget.observableNotifyInterval,
  )..publishWhileMounted(context);

  @override
  void dispose() {
    publisher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, publisher);
  }
}
