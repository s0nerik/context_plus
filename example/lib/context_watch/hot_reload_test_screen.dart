import 'dart:async';

import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

class HotReloadTestScreen extends StatefulWidget {
  const HotReloadTestScreen({super.key});

  static const urlPath = '/context_watch_hot_reload_test';

  @override
  State<HotReloadTestScreen> createState() => _HotReloadTestScreenState();
}

class _HotReloadTestScreenState extends State<HotReloadTestScreen> {
  bool _stream1HasListeners = false;
  late final StreamController<int> _controller1;
  late final Timer _timer1;
  late final Stream<int> _stream1 = _controller1.stream;

  bool _stream2HasListeners = false;
  late final StreamController<String> _controller2;
  late final Timer _timer2;
  late final Stream<String> _stream2 = _controller2.stream;

  bool _watchStream1 = true;
  bool _watchStream2 = false;
  int _reassembleCount = 0;

  @override
  void initState() {
    super.initState();
    _controller1 = StreamController<int>.broadcast(
      onListen: () => _stream1HasListeners = true,
      onCancel: () => _stream1HasListeners = false,
    );
    _timer1 = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      debugPrint(
        'Stream 1: ${timer.tick}, has listeners? $_stream1HasListeners',
      );
      _controller1.add(timer.tick % 10);
    });

    _controller2 = StreamController<String>.broadcast(
      onListen: () => _stream2HasListeners = true,
      onCancel: () => _stream2HasListeners = false,
    );
    _timer2 = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      debugPrint(
        '                                   Stream 2: ${timer.tick}, has listeners? $_stream2HasListeners',
      );
      _controller2.add(String.fromCharCode(65 + timer.tick % 26));
    });
  }

  @override
  void dispose() {
    _timer1.cancel();
    _controller1.close();
    _timer2.cancel();
    _controller2.close();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _reassembleCount++;
    if (_reassembleCount % 2 == 0) {
      _watchStream1 = true;
      _watchStream2 = false;
    } else {
      _watchStream1 = false;
      _watchStream2 = true;
    }
    debugPrint('reassemble, _watchStream1: $_watchStream1');
    debugPrint('reassemble, _watchStream2: $_watchStream2');
  }

  @override
  Widget build(BuildContext context) {
    final stream1Value =
        _watchStream1 ? _stream1.watch(context).data ?? -1 : -1;
    final stream2Value =
        _watchStream2 ? _stream2.watch(context).data ?? '' : '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Reload Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Digits: ${stream1Value != -1 ? stream1Value : ''}'),
            Text('Characters: $stream2Value'),
            const SizedBox(height: 16),
            Text('Reassemble count: $_reassembleCount'),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Each time you hot reload, the watched stream will change.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
