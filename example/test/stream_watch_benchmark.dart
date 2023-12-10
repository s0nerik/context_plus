// ignore_for_file: avoid_print

import 'dart:io';

import 'package:context_watch/context_watch.dart';
import 'package:example/benchmark_screen.dart';
import 'package:example/common/observable_listener_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Benchmark {
  _Benchmark({
    required ObservableType dataType,
    required ListenerType listenerType,
    int singleObservableSubscriptionsCount = 500,
    int tilesCount = 500,
    int observablesPerTile = 2,
    this.minimumMillis = 2000, // ignore: unused_element
    this.warmupMillis = 100, // ignore: unused_element
  }) : benchmark = BenchmarkScreen(
          observableType: dataType,
          listenerType: listenerType,
          singleObservableSubscriptionsCount:
              singleObservableSubscriptionsCount,
          tilesCount: tilesCount,
          observablesPerTile: observablesPerTile,
          tileObservableNotifyInterval: const Duration(milliseconds: 10),
          runOnStart: false,
          showPerformanceOverlay: false,
          visualize: false,
        );

  final BenchmarkScreen benchmark;
  final int minimumMillis;
  final int warmupMillis;

  late double resultMicroseconds;
}

// Run this with `flutter run --profile test/stream_watch_benchmark.dart`
main() async {
  assert(false); // fail in debug mode

  LiveTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> runBenchmark(_Benchmark benchmark) async {
    const frameDuration = Duration(milliseconds: 16, microseconds: 683);

    await benchmarkWidgets((WidgetTester tester) async {
      // Setup
      await tester.pumpWidget(
        ContextWatchRoot(
          key: UniqueKey(),
          child: MaterialApp(
            home: benchmark.benchmark,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('start')));
      await tester.pumpAndSettle();
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.benchmark;

      // Warmup
      var elapsedWarmup = 0;
      final warmupStopwatch = Stopwatch()..start();
      while (elapsedWarmup < benchmark.warmupMillis * 1000) {
        await tester.pumpBenchmark(frameDuration);
        elapsedWarmup = warmupStopwatch.elapsedMicroseconds;
      }

      // Benchmark
      final minimumMicros = benchmark.minimumMillis * 1000;
      var iter = 0;
      var elapsed = 0;
      final stopwatch = Stopwatch()..start();
      while (elapsed < minimumMicros) {
        await tester.pumpBenchmark(frameDuration);
        elapsed = stopwatch.elapsedMicroseconds;
        iter++;
      }
      benchmark.resultMicroseconds = elapsed / iter;

      // Teardown
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
      await tester.tap(find.byKey(const Key('stop')));
      await tester.pumpAndSettle();
    });
  }

  final tileBenchmarks = [1, 10, 100, 200, 500, 750, 1000, 5000, 10000, 20000]
      .expand((tilesCount) => [
            _Benchmark(
              dataType: StreamObservableType.stream,
              listenerType: StreamListenerType.contextWatch,
              singleObservableSubscriptionsCount: 0,
              tilesCount: tilesCount,
            ),
            _Benchmark(
              dataType: StreamObservableType.stream,
              listenerType: StreamListenerType.streamBuilder,
              singleObservableSubscriptionsCount: 0,
              tilesCount: tilesCount,
            ),
            _Benchmark(
              dataType: ListenableObservableType.valueListenable,
              listenerType: ListenableListenerType.contextWatch,
              singleObservableSubscriptionsCount: 0,
              tilesCount: tilesCount,
            ),
            _Benchmark(
              dataType: ListenableObservableType.valueListenable,
              listenerType: ValueListenableListenerType.valueListenableBuilder,
              singleObservableSubscriptionsCount: 0,
              tilesCount: tilesCount,
            ),
          ])
      .toList();
  final singleObservableBenchmarks = [1, 10, 100, 200, 500, 750, 1000]
      .expand((singleObservableSubscriptionsCount) => [
            _Benchmark(
              dataType: StreamObservableType.stream,
              listenerType: StreamListenerType.contextWatch,
              singleObservableSubscriptionsCount:
                  singleObservableSubscriptionsCount,
              tilesCount: 0,
            ),
            _Benchmark(
              dataType: StreamObservableType.stream,
              listenerType: StreamListenerType.streamBuilder,
              singleObservableSubscriptionsCount:
                  singleObservableSubscriptionsCount,
              tilesCount: 0,
            ),
            _Benchmark(
              dataType: ListenableObservableType.valueListenable,
              listenerType: ListenableListenerType.contextWatch,
              singleObservableSubscriptionsCount:
                  singleObservableSubscriptionsCount,
              tilesCount: 0,
            ),
            _Benchmark(
              dataType: ListenableObservableType.valueListenable,
              listenerType: ValueListenableListenerType.valueListenableBuilder,
              singleObservableSubscriptionsCount:
                  singleObservableSubscriptionsCount,
              tilesCount: 0,
            ),
          ])
      .toList();
  final benchmarks = [
    ...tileBenchmarks,
    ...singleObservableBenchmarks,
  ];

  for (final benchmark in benchmarks) {
    await runBenchmark(benchmark);
  }

  // Stream.watch(context) -> StreamBuilder
  final comparisons = <_Benchmark, _Benchmark>{};
  for (int i = 0; i < benchmarks.length; i += 2) {
    final contextWatchBenchmark = benchmarks[i];
    final streamBuilderBenchmark = benchmarks[i + 1];
    comparisons[contextWatchBenchmark] = streamBuilderBenchmark;
  }

  _printRow(
    summary: 'Summary',
    ratio: 'Ratio',
    totalSubscriptions: 'Total subscriptions',
    subscriptionsDescription: 'Subscriptions description',
    frameTimes: 'Frame times',
  );
  for (final contextWatchBenchmark in comparisons.keys) {
    final otherBenchmark = comparisons[contextWatchBenchmark]!;

    final tilesCount = contextWatchBenchmark.benchmark.tilesCount;
    final observablesPerTile =
        contextWatchBenchmark.benchmark.observablesPerTile;
    final singleObservableSubscriptionsCount =
        contextWatchBenchmark.benchmark.singleObservableSubscriptionsCount;
    final totalSubscriptionsCount =
        tilesCount * observablesPerTile + singleObservableSubscriptionsCount;

    final String benchmarkDescription;
    if (tilesCount == 0 && singleObservableSubscriptionsCount > 0) {
      benchmarkDescription =
          '$singleObservableSubscriptionsCount single stream subscriptions';
    } else if (tilesCount > 0 && singleObservableSubscriptionsCount == 0) {
      benchmarkDescription =
          '$tilesCount tiles * $observablesPerTile observables';
    } else {
      benchmarkDescription =
          '$tilesCount tiles * $observablesPerTile observables + $singleObservableSubscriptionsCount global subscriptions';
    }
    final totalSubsSummary = '$totalSubscriptionsCount total subs';

    final contextWatchTime = contextWatchBenchmark.resultMicroseconds;
    final otherTime = otherBenchmark.resultMicroseconds;

    final contextWatchName =
        contextWatchBenchmark.benchmark.observableType.displayName;
    final otherName = otherBenchmark.benchmark.observableType.displayName;

    final ratio = contextWatchTime / otherTime;
    final ratioStr = '${ratio.toStringAsFixed(2)}x';
    final contextWatchTimeStr = '${contextWatchTime.toStringAsFixed(2)}μs';
    final otherTimeStr = '${otherTime.toStringAsFixed(2)}μs';
    final frameTimesStr = '$contextWatchTimeStr/frame vs $otherTimeStr/frame';

    _printRow(
      summary: '$contextWatchName vs $otherName',
      ratio: ratioStr,
      totalSubscriptions: totalSubsSummary,
      subscriptionsDescription: benchmarkDescription,
      frameTimes: frameTimesStr,
    );
  }
  exit(0);
}

void _printRow({
  required String summary,
  required String ratio,
  required String totalSubscriptions,
  required String subscriptionsDescription,
  required String frameTimes,
}) {
  print([
    summary.padRight(60),
    ratio.padRight(7),
    totalSubscriptions.padRight(20),
    subscriptionsDescription.padRight(32),
    frameTimes.padRight(42),
  ].join('    '));
}
