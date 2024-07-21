import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import 'code_highlighter_theme.dart';
import 'user_agent/user_agent.dart';

class ExampleVariant {
  const ExampleVariant({
    required this.title,
    required this.file,
    required this.widget,
  });

  final String title;
  final String file;
  final Widget widget;
}

final _title = Ref<String>();
final _exampleVariants = Ref<List<ExampleVariant>>();
final _exampleDir = Ref<String>();
final _tabController = Ref<TabController>();

bool _isMobileLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 800;

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    required this.exampleDir,
    required this.title,
    required this.variants,
  });

  final String exampleDir;
  final String title;
  final List<ExampleVariant> variants;

  @override
  Widget build(BuildContext context) {
    _title.bindValue(context, title);
    _exampleDir.bindValue(context, exampleDir);
    _exampleVariants.bindValue(context, variants);
    _tabController.bind(
      context,
      (vsync) => TabController(vsync: vsync, length: variants.length),
      key: variants.length,
    );
    if (_isMobileLayout(context)) {
      return const _MobileLayout();
    }
    return const _DesktopLayout();
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    final title = _title.of(context);
    final exampleDir = _exampleDir.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(title),
            Text(
              'lib/examples/$exampleDir',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8) +
            MediaQuery.paddingOf(context),
        child: const Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: _SelectedExample(),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _SourceCode(),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  static final _selected = Ref<ValueNotifier<int>>();

  @override
  Widget build(BuildContext context) {
    final selected = _selected.bind(context, () => ValueNotifier(0));
    final title = _title.of(context);
    final exampleDir = _exampleDir.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(title),
            Text(
              'lib/examples/$exampleDir',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: MediaQuery.paddingOf(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 8,
              right: 8,
              top: 64,
              bottom: 8,
              child: IndexedStack(
                index: selected.watch(context),
                children: const [
                  _SourceCode(),
                  _SelectedExample(),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              left: 8,
              child: SegmentedButton(
                selected: {selected.watch(context)},
                onSelectionChanged: (selection) =>
                    selected.value = selection.first,
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: 0,
                    icon: Icon(MdiIcons.codeBraces),
                    label: Text('Code'),
                  ),
                  ButtonSegment(
                    value: 1,
                    icon: Icon(MdiIcons.applicationBraces),
                    label: Text('Example'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedExample extends StatelessWidget {
  const _SelectedExample();

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex =
        _tabController.watchOnly(context, (ctrl) => ctrl.index);
    final variants = _exampleVariants.of(context);
    return variants[selectedTabIndex].widget;
  }
}

class _SourceCode extends StatelessWidget {
  const _SourceCode();

  @override
  Widget build(BuildContext context) {
    final variants = _exampleVariants.of(context);
    return Card(
      child: Column(
        children: [
          TabBar(
            controller: _tabController.of(context),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              for (final variant in variants)
                _SourceCodeVariantTab(
                  key: ValueKey(variant.file),
                  variant: variant,
                ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController.of(context),
              children: [
                for (final variant in variants)
                  _SourceCodeVariantCode(
                    key: PageStorageKey(variant.file),
                    variant: variant,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCodeVariantTab extends StatelessWidget {
  const _SourceCodeVariantTab({
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
              'variants/${variant.file}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCodeVariantCode extends StatefulWidget {
  const _SourceCodeVariantCode({
    super.key,
    required this.variant,
  });

  final ExampleVariant variant;

  @override
  State<_SourceCodeVariantCode> createState() => _SourceCodeVariantCodeState();
}

class _SourceCodeVariantCodeState extends State<_SourceCodeVariantCode> {
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
      Brightness.dark => darkCodeThemeFuture,
      Brightness.light => lightCodeThemeFuture,
    }
        .watchOnly(context, (snap) => snap.data);
    final highlighter = codeTheme != null
        ? Highlighter(language: 'dart', theme: codeTheme)
        : null;

    final exampleDir = _exampleDir.of(context);
    final codeFileName = widget.variant.file;
    final codeFilePath = 'lib/examples/$exampleDir/variants/$codeFileName';
    final codeFuture = _fileContentFutures[codeFilePath] ??=
        DefaultAssetBundle.of(context)
            .loadString(codeFilePath)
            .then((value) => value.replaceAll(_importsRegexp, '').trim());
    final code = codeFuture.watchOnly(context, (snap) => snap.data);

    final scrollControllersGroup = _scrollControllersGroup
        .bind(context, LinkedScrollControllerGroup.new, key: codeFilePath);
    final lineNumbersController = _lineNumbersScrollController
        .bind(context, scrollControllersGroup.addAndGet, key: codeFilePath);
    final sourceScrollController = _sourceScrollController
        .bind(context, scrollControllersGroup.addAndGet, key: codeFilePath);

    if (highlighter == null || code == null) {
      return const SizedBox.shrink();
    }

    const codeStyleDesktop =
        TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13);
    const codeStyleMobile =
        TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10);
    final codeStyle =
        _isMobileLayout(context) ? codeStyleMobile : codeStyleDesktop;

    final lineNumberStyle = codeStyle.copyWith(color: Colors.grey[700]);
    final lineCount = code.split('\n').length;

    const padding = 12.0;

    Widget child = SingleChildScrollView(
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
    );

    if (!isMobileWebKit) {
      // Mobile WebKit doesn't handle text selection properly.
      // So let's enable it only for everything else.
      //
      // https://github.com/flutter/flutter/issues/95958
      // https://github.com/flutter/flutter/issues/122015
      child = SelectionArea(
        child: child,
      );
    }

    return Row(
      key: ValueKey(codeFilePath),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: _isMobileLayout(context) ? 28 : 32,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              controller: lineNumbersController,
              itemCount: lineCount,
              padding: const EdgeInsets.symmetric(vertical: padding),
              itemBuilder: (context, index) => Align(
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
          child: child,
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
