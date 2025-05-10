// ignore_for_file: avoid_print

import 'dart:io';

import 'package:context_plus/context_plus.dart';
import 'package:example/benchmarks/context_watch/benchmark_screen.dart';
import 'package:example/benchmarks/context_watch/common/observable_listener_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Benchmark {
  _Benchmark({
    required ObservableType dataType,
    required ListenerType listenerType,
    int tilesCount = 500,
    int observablesPerTile = 2,
    this.minimumMillis = 2000, // ignore: unused_element_parameter
    this.warmupMillis = 100, // ignore: unused_element_parameter
  }) : benchmark = BenchmarkScreen(
         observableType: dataType,
         listenerType: listenerType,
         tilesCount: tilesCount,
         observablesPerTile: observablesPerTile,
         tileObservableNotifyInterval: const Duration(milliseconds: 10),
         tileNotificationJitterMin: Duration.zero,
         tileNotificationJitterMax: const Duration(milliseconds: 10),
         runOnStart: false,
         showPerformanceOverlay: false,
         visualize: false,
       );

  final BenchmarkScreen benchmark;
  final int minimumMillis;
  final int warmupMillis;

  final frameTimes = List<int?>.filled(100000, null);

  List<int> get validFrameTimes => frameTimes.whereType<int>().toList();
  List<int> get trimmedFrameTimes => validFrameTimes.sublist(
    (validFrameTimes.length * 0.02).round(),
    validFrameTimes.length - (validFrameTimes.length * 0.02).round(),
  );

  int get worstFrameTime => validFrameTimes.reduce((a, b) => a > b ? a : b);
  int get bestFrameTime => validFrameTimes.reduce((a, b) => a < b ? a : b);

  int get worstTrimmedFrameTime =>
      trimmedFrameTimes.reduce((a, b) => a > b ? a : b);
  int get bestTrimmedFrameTime =>
      trimmedFrameTimes.reduce((a, b) => a < b ? a : b);

  int get averageFrameTime =>
      trimmedFrameTimes.reduce((a, b) => a + b) ~/ trimmedFrameTimes.length;
}

// Run this with `flutter run --profile benchmarks/benchmark_context_watch.dart`
main() async {
  assert(false); // fail in debug mode

  LiveTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> runBenchmark(_Benchmark benchmark) async {
    const frameDuration = Duration(milliseconds: 16, microseconds: 683);

    await benchmarkWidgets((WidgetTester tester) async {
      // Setup
      await tester.pumpWidget(
        ContextPlus.root(
          key: UniqueKey(),
          child: MaterialApp(home: benchmark.benchmark),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('start')));
      await tester.pumpAndSettle();
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.benchmark;

      // Benchmark
      final minimumMicros = benchmark.minimumMillis * 1000;
      final stopwatch = Stopwatch();
      late int endMicros;
      var iter = 0;
      do {
        final start = stopwatch.elapsedMicroseconds;
        stopwatch.start();
        await tester.pumpBenchmark(frameDuration);
        stopwatch.stop();
        endMicros = stopwatch.elapsedMicroseconds;
        benchmark.frameTimes[iter] = endMicros - start;
        iter++;
      } while (endMicros < minimumMicros);

      // Teardown
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
      await tester.tap(find.byKey(const Key('stop')));
      await tester.pumpAndSettle();
    });
  }

  final benchmarks = [
    for (final tilesCount in [1, 10, 100, 1000])
      for (final obsPerTile in [1, 10, 100]) ...[
        // _Benchmark(
        //   dataType: ObservableType.stream,
        //   listenerType: ListenerType.contextWatch,
        //   tilesCount: tilesCount,
        //   observablesPerTile: obsPerTile,
        // ),
        // _Benchmark(
        //   dataType: ObservableType.stream,
        //   listenerType: ListenerType.streamBuilder,
        //   tilesCount: tilesCount,
        //   observablesPerTile: obsPerTile,
        // ),
        _Benchmark(
          dataType: ObservableType.valueListenable,
          listenerType: ListenerType.contextWatch,
          tilesCount: tilesCount,
          observablesPerTile: obsPerTile,
        ),
        _Benchmark(
          dataType: ObservableType.valueListenable,
          listenerType: ListenerType.valueListenableBuilder,
          tilesCount: tilesCount,
          observablesPerTile: obsPerTile,
        ),
      ],
  ];

  for (final benchmark in benchmarks) {
    // Let the GC do its job
    await Future.delayed(const Duration(seconds: 2));
    // Run the benchmark
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
  for (final contextWatchResult in comparisons.keys) {
    final benchmark = contextWatchResult.benchmark;
    final otherResult = comparisons[contextWatchResult]!;
    final otherBenchmark = otherResult.benchmark;

    final tilesCount = benchmark.tilesCount;
    final observablesPerTile = benchmark.observablesPerTile;
    final totalSubscriptionsCount = tilesCount * observablesPerTile;

    final contextWatchName = benchmark.listenerType.displayName(
      benchmark.observableType,
    );
    final otherName = otherBenchmark.listenerType.displayName(
      otherBenchmark.observableType,
    );

    final contextWatchTime = contextWatchResult.averageFrameTime;
    final contextWatchTimeStr = '${contextWatchTime.toStringAsFixed(2)}μs';

    final otherTime = otherResult.averageFrameTime;
    final otherTimeStr = '${otherTime.toStringAsFixed(2)}μs';

    final contextWatchWorstTime = contextWatchResult.worstFrameTime;
    final contextWatchWorstTimeStr =
        '${contextWatchWorstTime.toStringAsFixed(2)}μs';

    final contextWatchWorstTrimmedTime =
        contextWatchResult.worstTrimmedFrameTime;
    final contextWatchWorstTrimmedTimeStr =
        '${contextWatchWorstTrimmedTime.toStringAsFixed(2)}μs';

    final otherWorstTrimmedTime = otherResult.worstTrimmedFrameTime;
    final otherWorstTrimmedTimeStr =
        '${otherWorstTrimmedTime.toStringAsFixed(2)}μs';

    final otherWorstTime = otherResult.worstFrameTime;
    final otherWorstTimeStr = '${otherWorstTime.toStringAsFixed(2)}μs';

    final frameTimesStr =
        '$contextWatchTimeStr/frame ($contextWatchWorstTimeStr / $contextWatchWorstTrimmedTimeStr) vs $otherTimeStr/frame ($otherWorstTimeStr / $otherWorstTrimmedTimeStr)';

    final ratio = contextWatchTime / otherTime;
    final ratioStr = '${ratio.toStringAsFixed(2)}x';

    _printRow(
      summary: '$contextWatchName vs $otherName',
      ratio: ratioStr,
      totalSubscriptions: '$totalSubscriptionsCount total subs',
      subscriptionsDescription:
          '$tilesCount tiles * $observablesPerTile observables',
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
  print(
    [
      summary.padRight(60),
      ratio.padRight(7),
      totalSubscriptions.padRight(20),
      subscriptionsDescription.padRight(32),
      frameTimes,
    ].join('    '),
  );
}
