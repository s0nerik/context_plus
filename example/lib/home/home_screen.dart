import 'package:context_plus/context_plus.dart';
import 'package:example/examples/showcase/showcase_example.dart';
import 'package:example/home/showcase/showcase.dart';
import 'package:example/home/widgets/code_quote.dart';
import 'package:example/home/widgets/low_emphasis_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:indent/indent.dart';
import 'package:url_router/url_router.dart';
import 'package:yaml/yaml.dart';

import '../benchmarks/context_watch/benchmark_screen.dart';
import '../examples/animation_controller/animation_controller_example.dart';
import '../examples/counter/counter_example.dart';
import '../examples/counter_with_propagation/counter_with_propagation_example.dart';
import '../examples/country_search/country_search_example.dart';
import '../examples/derived_state/derived_state_example.dart';
import '../examples/nested_scopes/nested_scopes_example.dart';
import '../examples/rainbow/rainbow_example.dart';
import '../other/context_watch_hot_reload_test_screen.dart';

const _horizontalMargin = 24.0;
const _gap = _horizontalMargin;

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
            if (isShowcaseCompleted.watchValue(context))
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SetupSection(),
                    _ExamplesSection(),
                    _DemonstrationsSection(),
                    Gap(_gap),
                  ],
                ),
              ),
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
          homeScrollController: _scrollController.of(context),
          onCompleted: () => _isShowcaseCompleted.of(context).value = true,
        ),
      ),
    );
  }
}

class _SetupSection extends StatelessWidget {
  const _SetupSection();

  @override
  Widget build(BuildContext context) {
    final displayAsRow = MediaQuery.sizeOf(context).width >=
        _horizontalMargin +
            _SetupStep1.minWidth +
            _gap +
            _SetupStep2.minWidth +
            _gap +
            _SetupStep3.minWidth +
            _horizontalMargin;

    final displayStep1AndStep2InRow = MediaQuery.sizeOf(context).width >=
        _horizontalMargin +
            _SetupStep1.minWidth +
            _gap +
            _SetupStep2.minWidth +
            _horizontalMargin;

    return _Section(
      header: const _SectionHeader(title: 'Setup'),
      child: displayAsRow
          ? const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SetupStep1(),
                Gap(_gap),
                _SetupStep2(),
                Gap(_gap),
                Flexible(child: _SetupStep3()),
              ],
            )
          : Column(
              crossAxisAlignment: displayStep1AndStep2InRow
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.stretch,
              children: [
                if (displayStep1AndStep2InRow)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SetupStep1(),
                      Gap(_gap),
                      _SetupStep2(),
                    ],
                  )
                else ...const [
                  _SetupStep1(),
                  Gap(_gap),
                  _SetupStep2(),
                ],
                const Gap(_gap),
                const _SetupStep3(),
              ],
            ),
    );
  }
}

class _SetupStep1 extends StatelessWidget {
  const _SetupStep1();

  static const minWidth = 258.0;

  static final _contextPlusVersion = Ref<Future<String>>();

  @override
  Widget build(BuildContext context) {
    final version = _contextPlusVersion
        .bind(context, () async {
          final yamlString =
              await DefaultAssetBundle.of(context).loadString('pubspec.yaml');
          final yaml = loadYaml(yamlString);
          final version = yaml['dependencies']['context_plus'] as String;
          return version;
        })
        .watch(context)
        .data;

    return _SetupStep(
      index: '1',
      child: Column(
        children: [
          const Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(text: 'Add the package to your\n'),
                WidgetSpan(
                  child: CodeQuote(
                    child: Text('pubspec.yaml'),
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          CodeMultilineQuote(
            fileName: 'pubspec.yaml',
            code: 'dependencies:\n  context_plus: $version',
            copyableCode: 'context_plus: $version',
          ),
        ],
      ),
    );
  }
}

class _SetupStep2 extends StatelessWidget {
  const _SetupStep2();

  static const minWidth = 266.0;

  @override
  Widget build(BuildContext context) {
    return const _SetupStep(
      index: '2',
      child: Column(
        children: [
          Text('Wrap your application with'),
          CodeQuote(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CodeType(type: 'ContextPlus', style: CodeStyle.vsCode),
                CodeFunctionCall(name: 'root', style: CodeStyle.vsCode),
              ],
            ),
          ),
          Gap(24),
          CodeMultilineQuote(
            fileName: 'lib/main.dart',
            code: 'void main() {\n'
                '  runApp(\n'
                '    ContextPlus.root(\n'
                '      MaterialApp(...),\n'
                '    ),\n'
                '  );\n'
                '}',
          ),
        ],
      ),
    );
  }
}

class _SetupStep3 extends StatelessWidget {
  const _SetupStep3();

  static const minWidth = 384.0;
  static const midWidth = 568.0;
  static const maxWidth = 724.0;

  static final _copyableCode = '''
    void main() {
      ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
      FlutterError.onError = ContextPlus.onError(FlutterError.onError);
      runApp(...);
    }
  '''
      .unindent()
      .trim();

  static final _midWidthCode = '''
    void main() {
      ErrorWidget.builder =
          ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
      FlutterError.onError =
          ContextPlus.onError(FlutterError.onError);
      runApp(...);
    }
  '''
      .unindent()
      .trim();

  static final _minWidthCode = '''
    void main() {
      ErrorWidget.builder =
          ContextPlus.errorWidgetBuilder(
              ErrorWidget.builder
          );
      FlutterError.onError =
          ContextPlus.onError(
              FlutterError.onError
          );
      runApp(...);
    }
  '''
      .unindent()
      .trim();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final code = constraints.maxWidth >= maxWidth
            ? _copyableCode
            : constraints.maxWidth >= midWidth
                ? _midWidthCode
                : _minWidthCode;
        return ConstrainedBox(
          constraints:
              const BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
          child: _SetupStep(
            index: '3',
            child: Column(
              children: [
                const Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              '(Optional, but recommended) Wrap default error handlers with '),
                      WidgetSpan(
                        child: CodeQuote(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CodeType(
                                  type: 'ContextPlus', style: CodeStyle.vsCode),
                              CodeFunctionCall(
                                  name: 'errorWidgetBuilder',
                                  style: CodeStyle.vsCode),
                            ],
                          ),
                        ),
                      ),
                      TextSpan(text: ' and '),
                      WidgetSpan(
                        child: CodeQuote(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CodeType(
                                  type: 'ContextPlus', style: CodeStyle.vsCode),
                              CodeFunctionCall(
                                  name: 'onError', style: CodeStyle.vsCode),
                            ],
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            ' to get more user-friendly error messages when known hot reload-preventing errors occur',
                      )
                    ],
                  ),
                ),
                const Gap(24),
                CodeMultilineQuote(
                  fileName: 'lib/main.dart',
                  code: code,
                  copyableCode: _copyableCode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.index,
    required this.child,
  });

  final String index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var indexStyle = Theme.of(context).textTheme.displayLarge!;
    indexStyle = indexStyle.copyWith(
      color: indexStyle.color!.withOpacity(0.05),
      height: 1,
      fontFamily: 'JetBrains Mono',
    );

    return LowEmphasisCard(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: -8,
            left: -8,
            child: Text(
              '#$index',
              style: indexStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicWidth(child: child),
          ),
        ],
      ),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      header: const _SectionHeader(
        title: 'Examples',
        subtitle:
            'All examples provide pure Flutter implementations as well for comparison',
      ),
      child: Wrap(
        spacing: _gap,
        runSpacing: _gap,
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
            description: const Text(CounterWithPropagationExample.description),
            tags: CounterWithPropagationExample.tags,
          ),
          _ExampleCard(
            onPressed: () => context.url = AnimationControllerExample.urlPath,
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
            onPressed: () => context.url = CountrySearchExample.urlPath,
            title: const Text(CountrySearchExample.title),
            description: const Text(CountrySearchExample.description),
            tags: CountrySearchExample.tags,
          ),
        ],
      ),
    );
  }
}

class _DemonstrationsSection extends StatelessWidget {
  const _DemonstrationsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      header: const _SectionHeader(
        title: 'Demonstrations',
      ),
      child: Wrap(
        spacing: _gap,
        runSpacing: _gap,
        children: [
          _ExampleCard(
            onPressed: () => context.url = NestedScopesExample.urlPath,
            title: const Text(NestedScopesExample.title),
            description: const Text(NestedScopesExample.description),
            tags: NestedScopesExample.tags,
          ),
          _ExampleCard(
            onPressed: () => context.url = DerivedStateExample.urlPath,
            title: const Text(DerivedStateExample.title),
            description: const Text(DerivedStateExample.description),
            tags: DerivedStateExample.tags,
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
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.header,
    required this.child,
  });

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
          child: child,
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
      padding: const EdgeInsets.only(
        left: _horizontalMargin,
        right: _horizontalMargin,
        top: _horizontalMargin * 2,
        bottom: _horizontalMargin / 2,
      ),
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
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
      child: Card(
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
