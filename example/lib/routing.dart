import 'package:example/examples/showcase/showcase_example.dart';
import 'package:flutter/material.dart';
import 'package:url_router/url_router.dart';

import 'benchmarks/context_watch/benchmark_screen.dart';
import 'examples/country_search/country_search_example.dart';
import 'examples/derived_state/derived_state_example.dart';
import 'examples/rainbow/rainbow_example.dart';
import 'examples/nested_scopes/nested_scopes_example.dart';
import 'examples/animation_controller/animation_controller_example.dart';
import 'examples/counter/counter_example.dart';
import 'examples/counter_with_propagation/counter_with_propagation_example.dart';
import 'home_screen.dart';
import 'other/context_watch_hot_reload_test_screen.dart';

Iterable<Widget?> _generatePageWidgets(UrlRouter router) sync* {
  yield const HomeScreen();
  yield switch (router.urlPath) {
    BenchmarkScreen.urlPath => const BenchmarkScreen(),
    ContextWatchHotReloadTestScreen.urlPath =>
      const ContextWatchHotReloadTestScreen(),
    NestedScopesExample.urlPath => const NestedScopesExample(),
    AnimationControllerExample.urlPath => const AnimationControllerExample(),
    RainbowExample.urlPath => const RainbowExample(),
    DerivedStateExample.urlPath => const DerivedStateExample(),
    CounterExample.urlPath => const CounterExample(),
    CounterWithPropagationExample.urlPath =>
      const CounterWithPropagationExample(),
    CountrySearchExample.urlPath => const CountrySearchExample(),
    ShowcaseExample.urlPath => const ShowcaseExample(),
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
