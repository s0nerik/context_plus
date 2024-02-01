import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

final _children = Ref<Map<String, Widget>>();

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final Map<String, Widget> children;

  @override
  Widget build(BuildContext context) {
    _children.bindValue(context, children);
    return DefaultTabController(
      length: children.length,
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
                        tabs: [
                          for (final fileName in children.keys)
                            Tab(text: fileName),
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

class _SelectedExample extends StatelessWidget {
  const _SelectedExample();

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = DefaultTabController.of(context).index;
    final widget = _children.of(context).values.elementAt(selectedTabIndex);
    return widget;
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

    final selectedTabIndex = DefaultTabController.of(context).index;
    final fileName = _children.of(context).keys.elementAt(selectedTabIndex);
    final codeFuture = _fileContentFutures[fileName] ??=
        DefaultAssetBundle.of(context)
            .loadString('lib/examples/$fileName')
            .then((value) => value.replaceAll(_importsRegexp, '').trim());
    final code = codeFuture.watch(context).data;

    if (highlighter == null || code == null) {
      return const SizedBox.shrink();
    }

    return InteractiveViewer(
      constrained: false,
      scaleEnabled: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text.rich(highlighter.highlight(code)),
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
