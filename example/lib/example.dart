import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.title,
    required this.fileName,
    required this.child,
  });

  final String title;
  final String fileName;
  final Widget child;

  static final _codeThemeFuture = HighlighterTheme.loadDarkTheme();
  static final _fileContentFutures = <String, Future<String>>{};
  static final _importsRegexp = RegExp(r"import '.*';\n");

  @override
  Widget build(BuildContext context) {
    final codeTheme = _codeThemeFuture.watch(context).data;
    final highlighter = codeTheme != null
        ? Highlighter(language: 'dart', theme: codeTheme)
        : null;

    final codeFuture = _fileContentFutures[fileName] ??=
        DefaultAssetBundle.of(context)
            .loadString('lib/examples/$fileName')
            .then((value) => value.replaceAll(_importsRegexp, '').trim());
    final code = codeFuture.watch(context).data;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: child,
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: highlighter != null && code != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InteractiveViewer(
                        constrained: false,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Text.rich(highlighter.highlight(code)),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
          ],
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
