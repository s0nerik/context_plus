import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class HotReloadTestScreen extends StatefulWidget {
  const HotReloadTestScreen({super.key});

  @override
  State<HotReloadTestScreen> createState() => _HotReloadTestScreenState();
}

class _HotReloadTestScreenState extends State<HotReloadTestScreen> {
  final _stream1 = Stream<int>.periodic(const Duration(seconds: 1), (i) => i)
      .shareValueSeeded(0);
  final _stream2 = Stream<double>.periodic(
          const Duration(milliseconds: 100), (i) => i.toDouble())
      .shareValueSeeded(0.0);

  bool _watchStream2 = false;

  @override
  void reassemble() {
    super.reassemble();
    _watchStream2 = !_watchStream2;
    debugPrint('reassemble, _watchStream2: $_watchStream2');
  }

  @override
  Widget build(BuildContext context) {
    final stream1Value = _stream1.watch(context).requireData;
    final stream2Value =
        _watchStream2 ? _stream2.watch(context).data ?? -1.0 : -1.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Reload Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Stream 1: $stream1Value'),
            Text('Stream 2: $stream2Value'),
          ],
        ),
      ),
    );
  }
}
