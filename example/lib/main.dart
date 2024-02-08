import 'package:context_plus/context_plus.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import 'examples/context_ref_bind_value_example_screen.dart';
import 'context_watch/benchmark_screen.dart';
import 'examples/context_ref_bind_example_screen.dart';
import 'examples/context_ref_nested_scopes_example_screen.dart';
import 'home_screen.dart';
import 'context_watch/hot_reload_test_screen.dart';

void main() {
  ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextPlus.onError(FlutterError.onError);
  signals.disableSignalsDevTools();
  runApp(const _App());
}

class _App extends StatefulWidget {
  const _App({super.key});

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
    Highlighter.initialize(['dart']);
  }

  @override
  Widget build(BuildContext context) {
    return ContextPlus.root(
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
          '/bind_value_example': (_) => const BindValueExampleScreen(),
        },
      ),
    );
  }
}
