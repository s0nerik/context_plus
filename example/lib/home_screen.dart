import 'package:context_plus/context_plus.dart';
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
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        pageSnapping: false,
        children: const [
          _IntroPage(),
          _ExamplesPage(),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
        Text(
          "Bind and observe values for a BuildContext, conveniently",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _IntroShortDescriptionArrow(),
          ],
        ),
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

class _ExamplesPage extends StatelessWidget {
  const _ExamplesPage();

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
              onPressed: () => context.url = AnimationControllerExample.urlPath,
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
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.url = CountrySearchExample.urlPath,
              child: const Text(CountrySearchExample.title),
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
