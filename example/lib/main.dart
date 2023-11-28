import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';

import 'benchmark_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextWatchRoot(
      child: MaterialApp(
        routes: {
          '/': (_) => const HomeScreen(),
          '/benchmark': (_) => BenchmarkScreen(),
        },
      ),
    );
  }
}
