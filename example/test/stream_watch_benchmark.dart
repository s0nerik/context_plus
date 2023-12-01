// ignore_for_file: avoid_print

import 'dart:io';

import 'package:context_watch/context_watch.dart';
import 'package:example/benchmark_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Run this with `flutter run --release test/stream_watch_benchmark.dart`
main() async {
  assert(false); // fail in debug mode
  await benchmarkWidgets((WidgetTester tester) async {
    final timers = {
      'Stream.watch(context)': Stopwatch(),
      'StreamBuilder': Stopwatch(),
    };
    Future<void> benchmark({
      required String name,
      bool useValueStream = true,
      int frames = 1000,
      int sideCount = 15,
    }) async {
      await tester.pumpWidget(
        ContextWatchRoot(
          key: Key(name),
          child: MaterialApp(
            home: BenchmarkScreen(
              dataType: useValueStream
                  ? BenchmarkDataType.valueStream
                  : BenchmarkDataType.stream,
              listenerType: name == 'StreamBuilder'
                  ? BenchmarkListenerType.streamBuilder
                  : BenchmarkListenerType.contextWatch,
              runOnStart: false,
              showPerformanceOverlay: false,
              sideCount: sideCount,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('start')));
      await tester.pumpAndSettle();
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.benchmark;
      timers[name]!.start();
      for (int i = 0; i < frames; i++) {
        await tester.pumpBenchmark(Duration.zero);
      }
      timers[name]!.stop();
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
      await tester.tap(find.byKey(const Key('stop')));
      await tester.pumpAndSettle();
    }

    for (var i = 0; i < 2; i++) {
      await benchmark(name: 'Stream.watch(context)');
      await benchmark(name: 'StreamBuilder');
    }

    final contextWatchTime =
        timers['Stream.watch(context)']!.elapsedMilliseconds;
    final streamBuilderTime = timers['StreamBuilder']!.elapsedMilliseconds;

    print('Stream.watch(context): ${contextWatchTime}ms');
    print('StreamBuilder: ${streamBuilderTime}ms');

    final results = [
      ('Stream.watch(context)', contextWatchTime),
      ('StreamBuilder', streamBuilderTime),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    final (fasterName, fasterTime) = results.first;
    final (slowerName, slowerTime) = results.last;
    final slowerPercent = (slowerTime / fasterTime).toStringAsFixed(2);
    print('$slowerName is ${slowerPercent}x slower than $fasterName');
  });
  exit(0);
}
