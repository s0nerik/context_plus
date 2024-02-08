import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class ExampleVariant {
  const ExampleVariant({
    required this.title,
    required this.filePath,
    required this.widget,
  });

  final String title;
  final String filePath;
  final Widget widget;
}

final _exampleVariants = Ref<List<ExampleVariant>>();

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    required this.title,
    required this.variants,
  });

  final String title;
  final List<ExampleVariant> variants;

  @override
  Widget build(BuildContext context) {
    _exampleVariants.bindValue(context, variants);
    return DefaultTabController(
      length: variants.length,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Expanded(
                flex: 1,
                child: _SelectedExample(),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: switch (Theme.of(context).brightness) {
                    Brightness.dark => Colors.grey[900],
                    Brightness.light => Colors.grey[200],
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: [
                          for (final variant in variants)
                            _Tab(
                              key: ValueKey(variant.filePath),
                              variant: variant,
                            ),
                        ],
                      ),
                      const Expanded(
                        child: _SelectedExampleCode(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    super.key,
    required this.variant,
  });

  final ExampleVariant variant;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(variant.title),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              variant.filePath,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedExample extends StatelessWidget {
  const _SelectedExample();

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex =
        DefaultTabController.of(context).watch(context).index;
    final variants = _exampleVariants.of(context);
    return IndexedStack(
      index: selectedTabIndex,
      children: [
        for (final variant in variants) variant.widget,
      ],
    );
  }
}

class _SelectedExampleCode extends StatelessWidget {
  const _SelectedExampleCode();

  static final _darkCodeThemeFuture = HighlighterTheme.loadDarkTheme();
  static final _lightCodeThemeFuture = HighlighterTheme.loadLightTheme();
  static final _fileContentFutures = <String, Future<String>>{};
  static final _importsRegexp = RegExp(r"import '.*';\n");

  @override
  Widget build(BuildContext context) {
    final codeTheme = switch (Theme.of(context).brightness) {
      Brightness.dark => _darkCodeThemeFuture,
      Brightness.light => _lightCodeThemeFuture,
    }
        .watch(context)
        .data;
    final highlighter = codeTheme != null
        ? Highlighter(language: 'dart', theme: codeTheme)
        : null;

    final selectedTabIndex =
        DefaultTabController.of(context).watch(context).index;
    final selectedVariant = _exampleVariants.of(context)[selectedTabIndex];
    final filePath = selectedVariant.filePath;
    final codeFuture = _fileContentFutures[filePath] ??=
        DefaultAssetBundle.of(context)
            .loadString('lib/examples/$filePath')
            .then((value) => value.replaceAll(_importsRegexp, '').trim());
    final code = codeFuture.watch(context).data;

    if (highlighter == null || code == null) {
      return const SizedBox.shrink();
    }

    return InteractiveViewer(
      key: ValueKey(code),
      constrained: false,
      scaleEnabled: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13),
          child: Text.rich(highlighter.highlight(code)),
        ),
      ),
    );
  }
}

class ExampleContainer extends StatelessWidget {
  const ExampleContainer({
    super.key,
    this.onTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      onTap: onTap,
      child: child,
    );
  }
}

class CounterExample extends StatelessWidget {
  const CounterExample({
    super.key,
    required this.counter,
  });

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: $counter',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to increment',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
