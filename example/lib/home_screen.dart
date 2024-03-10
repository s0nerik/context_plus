import 'package:flutter/material.dart';
import 'package:url_router/url_router.dart';

import 'benchmarks/context_watch/benchmark_screen.dart';
import 'examples/counter_with_propagation/counter_with_propagation_example.dart';
import 'examples/derived_state/derived_state_example.dart';
import 'examples/rainbow/rainbow_example.dart';
import 'examples/nested_scopes/nested_scopes_example.dart';
import 'examples/animation_controller/animation_controller_example.dart';
import 'examples/counter/counter_example.dart';
import 'other/context_watch_hot_reload_test_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('context_plus'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              _Group(
                title: 'Examples',
                children: [
                  OutlinedButton(
                    onPressed: () => context.url = CounterExample.urlPath,
                    child: const Text(CounterExample.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        context.url = CounterWithPropagationExample.urlPath,
                    child: const Text(CounterWithPropagationExample.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        context.url = AnimationControllerExample.urlPath,
                    child: const Text(AnimationControllerExample.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.url = RainbowExample.urlPath,
                    child: const Text(RainbowExample.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.url = NestedScopesExample.urlPath,
                    child: const Text(NestedScopesExample.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.url = DerivedStateExample.urlPath,
                    child: const Text(DerivedStateExample.title),
                  ),
                ],
              ),
              _Group(
                title: 'Other',
                children: [
                  OutlinedButton(
                    onPressed: () => context.url = BenchmarkScreen.urlPath,
                    child: const Text(BenchmarkScreen.title),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        context.url = ContextWatchHotReloadTestScreen.urlPath,
                    child: const Text(ContextWatchHotReloadTestScreen.title),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
