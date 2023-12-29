import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import 'context_watch/benchmark_screen.dart';
import 'context_ref/screens/bind_example_screen.dart';
import 'context_ref/screens/nested_scopes_example_screen.dart';
import 'home_screen.dart';
import 'context_watch/hot_reload_test_screen.dart';

void main() {
  ErrorWidget.builder = ContextRef.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextRef.onError(FlutterError.onError);
  signals.disableSignalsDevTools();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    Highlighter.initialize(['dart']);
  }

  @override
  Widget build(BuildContext context) {
    return ContextRef.root(
      child: ContextWatchRoot(
        additionalWatchers: [
          SignalContextWatcher.instance,
          MobxObservableWatcher.instance,
          BlocContextWatcher.instance,
          GetxContextWatcher.instance,
        ],
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          routes: {
            '/': (_) => const HomeScreen(),
            '/benchmark': (_) => const BenchmarkScreen(),
            '/hot_reload_test': (_) => const HotReloadTestScreen(),
            '/nested_scopes_example': (_) => const NestedScopesExampleScreen(),
            '/bind_example': (_) => const BindExampleScreen(),
          },
        ),
      ),
    );
  }
}
