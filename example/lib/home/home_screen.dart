import 'package:context_plus/context_plus.dart';
import 'package:example/examples/showcase/showcase_example.dart';
import 'package:example/home/showcase/showcase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_router/url_router.dart';

import '../benchmarks/context_watch/benchmark_screen.dart';
import '../examples/animation_controller/animation_controller_example.dart';
import '../examples/counter/counter_example.dart';
import '../examples/counter_with_propagation/counter_with_propagation_example.dart';
import '../examples/country_search/country_search_example.dart';
import '../examples/derived_state/derived_state_example.dart';
import '../examples/nested_scopes/nested_scopes_example.dart';
import '../examples/rainbow/rainbow_example.dart';
import '../other/context_watch_hot_reload_test_screen.dart';

final _scrollController = Ref<ScrollController>();
final _isShowcaseCompleted = Ref<ValueNotifier<bool>>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = _scrollController.bind(context, ScrollController.new);
    final isShowcaseCompleted =
        _isShowcaseCompleted.bind(context, () => ValueNotifier(false));
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ShowcasePage(),
            if (isShowcaseCompleted.watch(context)) ...[
              _Section(
                header: const _SectionHeader(
                  title: 'Examples',
                  subtitle:
                      'All examples provide pure Flutter implementations as well for comparison',
                ),
                children: [
                  _ExampleCard(
                    onPressed: () => context.url = ShowcaseExample.urlPath,
                    title: const Text(ShowcaseExample.title),
                    description: const Text(ShowcaseExample.description),
                    tags: ShowcaseExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () => context.url = CounterExample.urlPath,
                    title: const Text(CounterExample.title),
                    description: const Text(CounterExample.description),
                    tags: CounterExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () =>
                        context.url = CounterWithPropagationExample.urlPath,
                    title: const Text(CounterWithPropagationExample.title),
                    description:
                        const Text(CounterWithPropagationExample.description),
                    tags: CounterWithPropagationExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () =>
                        context.url = AnimationControllerExample.urlPath,
                    title: const Text(AnimationControllerExample.title),
                    description:
                        const Text(AnimationControllerExample.description),
                    tags: AnimationControllerExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () => context.url = RainbowExample.urlPath,
                    title: const Text(RainbowExample.title),
                    description: const Text(RainbowExample.description),
                    tags: RainbowExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () => context.url = DerivedStateExample.urlPath,
                    title: const Text(DerivedStateExample.title),
                    description: const Text(DerivedStateExample.description),
                    tags: DerivedStateExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () => context.url = CountrySearchExample.urlPath,
                    title: const Text(CountrySearchExample.title),
                    description: const Text(CountrySearchExample.description),
                    tags: CountrySearchExample.tags,
                  ),
                ],
              ),
              _Section(
                header: const _SectionHeader(title: 'Other'),
                children: [
                  _ExampleCard(
                    onPressed: () => context.url = NestedScopesExample.urlPath,
                    title: const Text(NestedScopesExample.title),
                    description: const Text(NestedScopesExample.description),
                    tags: NestedScopesExample.tags,
                  ),
                  _ExampleCard(
                    onPressed: () => context.url = BenchmarkScreen.urlPath,
                    title: const Text(BenchmarkScreen.title),
                    description: const Text(BenchmarkScreen.description),
                    tags: BenchmarkScreen.tags,
                  ),
                  if (kDebugMode)
                    _ExampleCard(
                      onPressed: () =>
                          context.url = ContextWatchHotReloadTestScreen.urlPath,
                      title: const Text(ContextWatchHotReloadTestScreen.title),
                      description: const Text(
                          ContextWatchHotReloadTestScreen.description),
                      tags: ContextWatchHotReloadTestScreen.tags,
                    ),
                ],
              ),
              const Gap(12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShowcasePage extends StatelessWidget {
  const _ShowcasePage();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final allowAnimations =
        _scrollController.watchOnly(context, (ctrl) => ctrl.offset < height);
    return SizedBox(
      height: height,
      child: TickerMode(
        enabled: allowAnimations,
        child: Showcase(
          onCompleted: () => _isShowcaseCompleted.of(context).value = true,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.header,
    required this.children,
  });

  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(children: children),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    this.description,
    this.tags = const <String>[],
    required this.onPressed,
  });

  final Widget title;
  final Widget? description;
  final List<String> tags;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        margin: const EdgeInsets.all(12),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge!,
                  textHeightBehavior: const TextHeightBehavior(
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  child: title,
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  description!,
                ],
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in tags)
                        Chip(
                          label: Text(tag),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
