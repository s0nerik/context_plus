import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: DefaultTabController(
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
    final selectedTabIndex = DefaultTabController.of(context)
        .watchOnly(context, (ctrl) => ctrl.index);
    final variants = _exampleVariants.of(context);
    return variants[selectedTabIndex].widget;
  }
}

class _SelectedExampleCode extends StatefulWidget {
  const _SelectedExampleCode();

  @override
  State<_SelectedExampleCode> createState() => _SelectedExampleCodeState();
}

class _SelectedExampleCodeState extends State<_SelectedExampleCode> {
  static final _darkCodeThemeFuture = HighlighterTheme.loadDarkTheme();
  static final _lightCodeThemeFuture = HighlighterTheme.loadLightTheme();
  static final _fileContentFutures = <String, Future<String>>{};
  static final _importsRegexp = RegExp(r"import '.*';\n");

  static final _scrollControllersGroup = Ref<LinkedScrollControllerGroup>();
  static final _lineNumbersScrollController = Ref<ScrollController>();
  static final _sourceScrollController = Ref<ScrollController>();

  @override
  void reassemble() {
    _fileContentFutures.clear();
    super.reassemble();
  }

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

    final tabController = DefaultTabController.of(context).watch(context);
    final selectedTabIndex = tabController.index;
    final selectedVariant = _exampleVariants.of(context)[selectedTabIndex];
    final filePath = selectedVariant.filePath;
    final codeFuture = _fileContentFutures[filePath] ??=
        DefaultAssetBundle.of(context)
            .loadString('lib/examples/$filePath')
            .then((value) => value.replaceAll(_importsRegexp, '').trim());
    final code = codeFuture.watch(context).data;

    final scrollControllersGroup = _scrollControllersGroup.bind(
        context, key: filePath, LinkedScrollControllerGroup.new);
    final lineNumbersController = _lineNumbersScrollController.bind(
        context, key: filePath, scrollControllersGroup.addAndGet);
    final sourceScrollController = _sourceScrollController.bind(
        context, key: filePath, scrollControllersGroup.addAndGet);

    if (highlighter == null || code == null) {
      return const SizedBox.shrink();
    }

    const codeStyle = TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13);
    final lineNumberStyle = codeStyle.copyWith(color: Colors.grey[700]);
    final lineCount = code.split('\n').length;

    const padding = 12.0;
    return Row(
      key: ValueKey(filePath),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              controller: lineNumbersController,
              itemCount: lineCount,
              padding: const EdgeInsets.symmetric(vertical: padding),
              itemBuilder: (context, index) => Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '${index + 1}',
                  style: lineNumberStyle,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: sourceScrollController,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: padding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: DefaultTextStyle.merge(
                style: codeStyle,
                child: Text.rich(highlighter.highlight(code)),
              ),
            ),
          ),
        ),
      ],
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
    this.onTap,
  });

  final int counter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Center(
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

    if (onTap != null) {
      return ExampleContainer(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}
