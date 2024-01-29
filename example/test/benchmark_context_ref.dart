import 'package:context_plus/context_plus.dart';
import 'package:dolumns/dolumns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum _BenchmarkType {
  inheritedWidget,
  contextRef,
}

class _Benchmark {
  _Benchmark({
    required this.depth,
    required this.extraBreadthEvery,
    required int? extraBreadthAmount,
    required this.type,
  }) : extraBreadthAmount = extraBreadthAmount ?? 1 {
    final (widget, totalWidgets) = _buildTree(
      depth: depth,
      extraBreadthEvery: extraBreadthEvery,
      extraBreadthAmount: this.extraBreadthAmount,
      type: type,
    );
    this.widget = widget;
    this.totalWidgets = totalWidgets;
  }

  final int depth;
  final int? extraBreadthEvery;
  final int extraBreadthAmount;
  final _BenchmarkType type;

  late final Widget widget;
  late final int totalWidgets;

  final int minimumMillis = 2000;
  final int warmupMillis = 100;

  late double resultMicroseconds;
}

// Run this with `flutter run --profile test/benchmark_context_ref.dart`
main() async {
  // assert(false); // fail in debug mode

  LiveTestWidgetsFlutterBinding.ensureInitialized();
  LiveTestWidgetsFlutterBinding.instance.framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> runBenchmark(_Benchmark benchmark) async {
    const frameDuration = Duration(milliseconds: 16, microseconds: 683);

    await benchmarkWidgets((WidgetTester tester) async {
      // Setup
      final rebuildTrigger = ValueNotifier(0);
      await tester.pumpWidget(
        MaterialApp(
          home: _ContextRefBenchmarkScreen(
            key: UniqueKey(),
            rebuildTrigger: rebuildTrigger,
            benchmark: benchmark,
          ),
        ),
      );
      rebuildTrigger.value++;
      await tester.pumpAndSettle();
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.benchmark;

      // Warmup
      var elapsedWarmup = 0;
      final warmupStopwatch = Stopwatch()..start();
      while (elapsedWarmup < benchmark.warmupMillis * 1000) {
        rebuildTrigger.value++;
        await tester.pumpBenchmark(frameDuration);
        elapsedWarmup = warmupStopwatch.elapsedMicroseconds;
      }

      // Benchmark
      final minimumMicros = benchmark.minimumMillis * 1000;
      var iter = 0;
      var elapsed = 0;
      final stopwatch = Stopwatch()..start();
      while (elapsed < minimumMicros) {
        rebuildTrigger.value++;
        await tester.pumpBenchmark(frameDuration);
        elapsed = stopwatch.elapsedMicroseconds;
        iter++;
      }
      benchmark.resultMicroseconds = elapsed / iter;

      // Teardown
      LiveTestWidgetsFlutterBinding.instance.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
      rebuildTrigger.value++;
      await tester.pumpAndSettle();
    });
  }

  Future<(_Benchmark inheritedWidget, _Benchmark contextRef)>
      runComparisonBenchmarks({
    required int depth,
    int? extraBreadthEvery,
    int? extraBreadthAmount,
  }) async {
    final inheritedWidgetBenchmark = _Benchmark(
      depth: depth,
      extraBreadthEvery: extraBreadthEvery,
      extraBreadthAmount: extraBreadthAmount,
      type: _BenchmarkType.inheritedWidget,
    );
    await runBenchmark(inheritedWidgetBenchmark);

    final contextRefBenchmark = _Benchmark(
      depth: depth,
      extraBreadthEvery: extraBreadthEvery,
      extraBreadthAmount: extraBreadthAmount,
      type: _BenchmarkType.contextRef,
    );
    await runBenchmark(contextRefBenchmark);

    return (inheritedWidgetBenchmark, contextRefBenchmark);
  }

  final results = <(_Benchmark, _Benchmark)>[
    await runComparisonBenchmarks(depth: 2),
    await runComparisonBenchmarks(depth: 5),
    await runComparisonBenchmarks(depth: 10),
    await runComparisonBenchmarks(depth: 100),
    // Bigger depth is so unrealistic that Flutter itself crashes with
    // Stack Overflow error.
    await runComparisonBenchmarks(depth: 1000),
    await runComparisonBenchmarks(depth: 10, extraBreadthEvery: 1),
    await runComparisonBenchmarks(depth: 100, extraBreadthEvery: 10),
    await runComparisonBenchmarks(depth: 1000, extraBreadthEvery: 100),
  ];

  final resultTable = dolumnify([
    [
      'total widgets',
      'depth',
      'extra breadth every Nth depth',
      'extra breadth amount',
      'ratio',
      'ContextRef (μs)',
      'InheritedWidget (μs)'
    ],
    ...results.map((result) {
      final (inheritedWidget, contextRef) = result;
      return [
        contextRef.totalWidgets,
        contextRef.depth,
        contextRef.extraBreadthEvery?.toString() ?? 'none',
        contextRef.extraBreadthAmount.toString(),
        (contextRef.resultMicroseconds / inheritedWidget.resultMicroseconds)
            .toStringAsFixed(2),
        (contextRef.resultMicroseconds).toStringAsFixed(2),
        (inheritedWidget.resultMicroseconds).toStringAsFixed(2),
      ];
    }),
  ], headerIncluded: true, headerSeparator: '-', columnSplitter: ' | ');

  for (final line in resultTable.split('\n')) {
    print(line); // ignore: avoid_print
  }
}

class _ContextRefBenchmarkScreen extends StatefulWidget {
  const _ContextRefBenchmarkScreen({
    super.key,
    required this.rebuildTrigger,
    required this.benchmark,
  });

  final Listenable rebuildTrigger;
  final _Benchmark benchmark;

  @override
  State<_ContextRefBenchmarkScreen> createState() =>
      _ContextRefBenchmarkScreenState();
}

class _ContextRefBenchmarkScreenState
    extends State<_ContextRefBenchmarkScreen> {
  @override
  void initState() {
    super.initState();
    widget.rebuildTrigger.addListener(_rebuild);
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.rebuildTrigger.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ContextRef Benchmark'),
      ),
      body: switch (widget.benchmark.type) {
        _BenchmarkType.inheritedWidget => _InheritedProvider(
            value: 1,
            child: KeyedSubtree(
              key: UniqueKey(),
              child: widget.benchmark.widget,
            ),
          ),
        _BenchmarkType.contextRef => ContextPlus.root(
            child: _ContextRefProvider(
              value: 1,
              child: KeyedSubtree(
                key: UniqueKey(),
                child: widget.benchmark.widget,
              ),
            ),
          ),
      },
    );
  }
}

final _ref = Ref<int>();

class _ContextRefProvider extends StatelessWidget {
  const _ContextRefProvider({
    required this.value,
    required this.child,
  });

  final int value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    _ref.bindValue(context, value);
    return child;
  }
}

class _ContextRefReader extends StatelessWidget {
  const _ContextRefReader();

  @override
  Widget build(BuildContext context) {
    _ref.of(context);
    return const SizedBox.shrink();
  }
}

class _InheritedProvider extends InheritedWidget {
  const _InheritedProvider({
    required this.value,
    required super.child,
  });

  final int value;

  static int of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedProvider>()!
        .value;
  }

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return value != oldWidget.value;
  }
}

class _InheritedReader extends StatelessWidget {
  const _InheritedReader();

  @override
  Widget build(BuildContext context) {
    _InheritedProvider.of(context);
    return const SizedBox.shrink();
  }
}

(Widget, int totalWidgets) _buildTree({
  required int depth,
  required int? extraBreadthEvery,
  required int extraBreadthAmount,
  required _BenchmarkType type,
}) {
  int currentDepth = depth;

  final depthWidgets = <int, int>{};
  depthWidgets[depth] = 1; // _InheritedReader/_ContextRefReader
  final leafWidget = switch (type) {
    _BenchmarkType.inheritedWidget => const _InheritedReader(),
    _BenchmarkType.contextRef => const _ContextRefReader(),
  };
  Widget widget = leafWidget;

  while (currentDepth > 1) {
    currentDepth -= 1;

    final shouldAddExtraBreadth =
        extraBreadthEvery != null && currentDepth % extraBreadthEvery == 0;

    final totalWidgets =
        depthWidgets.values.reduce((value, element) => value + element);
    // Column + all existing widgets (if extra breadth is requested)
    depthWidgets[currentDepth] = (depthWidgets[currentDepth] ?? 0) +
        1 +
        (shouldAddExtraBreadth ? extraBreadthAmount * totalWidgets : 0);

    widget = Column(
      children: [
        if (shouldAddExtraBreadth)
          for (int i = 0; i < extraBreadthAmount; i++) widget,
        widget,
      ],
    );
  }

  final totalWidgets =
      depthWidgets.values.reduce((value, element) => value + element);
  return (widget, totalWidgets);
}
