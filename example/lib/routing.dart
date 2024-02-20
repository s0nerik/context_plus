import 'package:flutter/material.dart';
import 'package:url_router/url_router.dart';

import 'benchmarks/context_watch/benchmark_screen.dart';
import 'examples/context_plus_rainbow_example_screen.dart';
import 'examples/context_plus_screen_state_example_screen.dart';
import 'examples/context_ref_bind_example_screen.dart';
import 'examples/context_ref_bind_value_example_screen.dart';
import 'examples/context_ref_nested_scopes_example_screen.dart';
import 'examples/context_watch_example_screen.dart';
import 'examples/context_watch_listenable_example_screen.dart';
import 'examples/counter_example_screen.dart';
import 'home_screen.dart';
import 'other/context_watch_hot_reload_test_screen.dart';

Iterable<Widget?> _generatePageWidgets(UrlRouter router) sync* {
  yield const HomeScreen();
  yield switch (router.urlPath) {
    BenchmarkScreen.urlPath => const BenchmarkScreen(),
    ContextWatchHotReloadTestScreen.urlPath =>
      const ContextWatchHotReloadTestScreen(),
    NestedScopesExampleScreen.urlPath => const NestedScopesExampleScreen(),
    BindExampleScreen.urlPath => const BindExampleScreen(),
    BindValueExampleScreen.urlPath => const BindValueExampleScreen(),
    ContextWatchExampleScreen.urlPath => const ContextWatchExampleScreen(),
    ContextPlusBindWatchExampleScreen.urlPath =>
      const ContextPlusBindWatchExampleScreen(),
    ContextWatchListenableExampleScreen.urlPath =>
      const ContextWatchListenableExampleScreen(),
    ContextPlusScreenStateExampleScreen.urlPath =>
      const ContextPlusScreenStateExampleScreen(),
    CounterExampleScreen.urlPath => const CounterExampleScreen(),
    _ => null,
  };
}

UrlRouter createRouter() {
  List<Page> generatePages(UrlRouter router) => _generatePageWidgets(router)
      .nonNulls
      .map((screen) => MaterialPage(child: screen))
      .toList();

  late final UrlRouter router;
  return router = UrlRouter(
    onGeneratePages: generatePages,
    onPopPage: (route, result) {
      final pages = generatePages(router);
      if (pages.length > 1 && route.didPop(result)) {
        final uri = Uri.parse(router.url);
        final newPathSegments =
            uri.pathSegments.take(uri.pathSegments.length - 1);
        router.url = uri.replace(pathSegments: newPathSegments).toString();
        return true;
      }
      return false;
    },
  );
}
