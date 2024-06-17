import 'package:context_plus/context_plus.dart';
import 'package:example/examples/showcase/showcase_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:url_router/url_router.dart';

import 'benchmarks/context_watch/benchmark_screen.dart';
import 'examples/counter_with_propagation/counter_with_propagation_example.dart';
import 'examples/country_search/country_search_example.dart';
import 'examples/derived_state/derived_state_example.dart';
import 'examples/rainbow/rainbow_example.dart';
import 'examples/nested_scopes/nested_scopes_example.dart';
import 'examples/animation_controller/animation_controller_example.dart';
import 'examples/counter/counter_example.dart';
import 'other/context_watch_hot_reload_test_screen.dart';

const _margin = 24.0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Intro(),
            _Examples(),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: _margin),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _margin),
              child: _IntroImage(),
            ),
          ),
          SizedBox(height: 24),
          _IntroShortDescription(),
          SizedBox(height: _margin),
        ],
      ),
    );
  }
}

class _IntroImage extends StatelessWidget {
  const _IntroImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/context_plus.png',
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    );
  }
}

class _IntroShortDescription extends StatelessWidget {
  const _IntroShortDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: Theme.of(context).textTheme.titleLarge,
              children: const [
                TextSpan(text: 'Bind and observe values for a '),
                TextSpan(
                  text: 'BuildContext',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                TextSpan(text: ', conveniently.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const _IntroShortDescriptionArrow(),
      ],
    );
  }
}

class _IntroShortDescriptionArrow extends StatelessWidget {
  const _IntroShortDescriptionArrow();

  static final _animCtrl = Ref<AnimationController>();
  static final _anim = Ref<SequenceAnimation>();

  @override
  Widget build(BuildContext context) {
    final animCtrl = _animCtrl.bind(
      context,
      (vsync) => AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 1),
      )..repeat(),
    );

    final anim = _anim.bind(
      context,
      () => SequenceAnimationBuilder()
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration.zero,
            to: const Duration(milliseconds: 300),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: -8, end: 0),
            from: Duration.zero,
            to: const Duration(milliseconds: 300),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 1),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 600),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 0),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 600),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 0),
            from: const Duration(milliseconds: 600),
            to: const Duration(milliseconds: 900),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 8),
            from: const Duration(milliseconds: 600),
            to: const Duration(milliseconds: 900),
            tag: 'translateY',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 0),
            from: const Duration(milliseconds: 900),
            to: const Duration(milliseconds: 1000),
            tag: 'opacity',
          )
          .addAnimatable(
            animatable: Tween<double>(begin: 8, end: 8),
            from: const Duration(milliseconds: 900),
            to: const Duration(milliseconds: 1000),
            tag: 'translateY',
          )
          .animate(animCtrl),
    );

    return Transform.translate(
      offset: Offset(0, anim['translateY'].watch(context)),
      child: Opacity(
        opacity: anim['opacity'].watch(context),
        child: const Icon(MdiIcons.chevronDoubleDown),
      ),
    );
  }
}

class _Examples extends StatelessWidget {
  const _Examples();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: _margin),
        const _SectionHeader(
          title: 'Examples',
          subtitle:
              'All examples provide pure Flutter implementations as well for comparison',
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
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
                description: const Text(AnimationControllerExample.description),
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
        ),
        const _SectionHeader(
          title: 'Other',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
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
                  description:
                      const Text(ContextWatchHotReloadTestScreen.description),
                  tags: ContextWatchHotReloadTestScreen.tags,
                ),
            ],
          ),
        ),
        const SizedBox(height: _margin),
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
