import 'package:context_watch/context_watch.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;
import 'package:flutter/material.dart';

import 'benchmark_screen.dart';
import 'home_screen.dart';
import 'hot_reload_test_screen.dart';

void main() {
  signals.disableSignalsDevTools();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextWatchRoot(
      additionalWatchers: [
        SignalContextWatcher.instance,
        MobxObservableWatcher.instance,
        BlocContextWatcher.instance,
        GetxContextWatcher.instance,
      ],
      child: MaterialApp(
        routes: {
          '/': (_) => const HomeScreen(),
          '/benchmark': (_) => const BenchmarkScreen(),
          '/hot_reload_test': (_) => const HotReloadTestScreen(),
        },
      ),
    );
  }
}
