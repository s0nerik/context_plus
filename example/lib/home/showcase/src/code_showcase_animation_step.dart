import 'package:context_plus/context_plus.dart';
import 'package:example/home/showcase/src/background_gradient.dart';
import 'package:example/home/widgets/code_quote.dart';
import 'package:example/home/widgets/low_emphasis_card.dart';
import 'package:example/other/const_tween.dart';
import 'package:example/other/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'code.dart';
import 'copyable_widget_span.dart';

final _codeAnimCtrl = Ref<CodeAnimationController>();
final _mobileExpandCtrl = Ref<AnimationController?>();

class CodeShowcaseProgressStep extends StatelessWidget {
  const CodeShowcaseProgressStep({
    super.key,
    required this.codeAnimCtrl,
    required this.expandCtrl,
    required this.step,
    required this.isMobileLayout,
  });

  final CodeAnimationController codeAnimCtrl;
  final AnimationController? expandCtrl;
  final int step;
  final bool isMobileLayout;

  @override
  Widget build(BuildContext context) {
    _codeAnimCtrl.bindValue(context, codeAnimCtrl);
    _mobileExpandCtrl.bindValue(context, expandCtrl);

    return AnimatedBuilder(
      animation: codeAnimCtrl,
      builder: (context, child) {
        final stepProgress = codeAnimCtrl.stepProgress(step);
        final opacity = isMobileLayout ? stepProgress : stepProgress.clamp(0.5, 1.0);
        return Opacity(opacity: opacity, child: child!);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMobileLayout) const SizedBox(height: 56, child: BackgroundGradient()),
          Material(
            clipBehavior: Clip.none,
            color: isMobileLayout ? BackgroundGradient.endColor : Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: isMobileLayout ? const EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.zero,
                  child: _Title(step: step, isMobileLayout: isMobileLayout),
                ),
                Padding(
                  padding: isMobileLayout
                      ? const EdgeInsets.only(left: 16, right: 16, bottom: 8)
                      : const EdgeInsets.only(left: 34),
                  child: _Description(step: step),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _titles = {0: _vanillaFlutterTitle, 1: _refTitle, 2: _bindTitle, 3: _watchTitle};
const _descriptions = {0: _vanillaFlutterDescription, 1: _refDescription, 2: _bindDescription, 3: _watchDescription};

const _vanillaFlutterTitle = TextSpan(
  children: [
    WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: SvgPicture(
          SvgAssetLoader('assets/svg/emoji_u1f44b.svg'), // 👋
          width: 16,
          height: 16,
        ),
      ),
    ),
    TextSpan(text: '  '),
    TextSpan(text: 'Meet '),
    WidgetSpan(
      child: CodeQuote(child: CodeType(type: 'context_plus')),
    ),
    TextSpan(text: '!'),
  ],
);
const _vanillaFlutterDescription = TextSpan(
  children: [
    TextSpan(text: 'See this bulky piece of pure Flutter code?'),
    TextSpan(text: '\n\n'),
    TextSpan(text: 'We can halve it!'),
    TextSpan(text: '\n'),
    TextSpan(text: 'Let me show you how.'),
    TextSpan(text: ' '),
    CopyableWidgetSpan(
      index: 0,
      plainText: '🚀',
      child: SvgPicture(
        SvgAssetLoader('assets/svg/emoji_u1f680.svg'), // 🚀
        width: 16,
        height: 16,
      ),
    ),
  ],
);

const _refTitle = TextSpan(
  children: [
    WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: SvgPicture(
          SvgAssetLoader('assets/svg/emoji_u1f517.svg'), // 🔗
          width: 16,
          height: 16,
        ),
      ),
    ),
    TextSpan(text: '  '),
    TextSpan(text: 'Create a '),
    WidgetSpan(
      child: CodeQuote(child: CodeType(type: 'Ref')),
    ),
  ],
);
const _refDescription = TextSpan(
  children: [
    CopyableWidgetSpan(
      index: 0,
      plainText: '`Ref<T>`',
      child: CodeQuote(
        child: CodeType(type: 'Ref', genericTypes: ['T']),
      ),
    ),
    TextSpan(text: ' is a reference to a value of type '),
    CopyableWidgetSpan(
      index: 1,
      plainText: '`T`',
      child: CodeQuote(child: CodeType(type: 'T')),
    ),
    TextSpan(text: ' provided by a parent '),
    CopyableWidgetSpan(
      index: 2,
      plainText: '`BuildContext`',
      child: CodeQuote(child: CodeType(type: 'BuildContext')),
    ),
    TextSpan(text: '.'),
    TextSpan(text: '\n\n'),
    TextSpan(text: 'It behaves similarly to '),
    CopyableWidgetSpan(
      index: 3,
      plainText: '`InheritedWidget`',
      child: CodeQuote(child: CodeType(type: 'InheritedWidget')),
    ),
    TextSpan(text: ' with a single value property and provides a conventional '),
    CopyableWidgetSpan(
      index: 4,
      plainText: '`.of(context)`',
      child: CodeQuote(
        child: CodeFunctionCall(
          name: 'of',
          params: [CodeParameter(name: 'context')],
        ),
      ),
    ),
    TextSpan(text: ' method to access the value.'),
    TextSpan(text: '\n\n'),
    CopyableWidgetSpan(
      index: 5,
      plainText: '`Ref<AnyObservableType>`',
      child: CodeQuote(
        child: CodeType(type: 'Ref', genericTypes: ['{Stream|Future|Listenable|ValueListenable}']),
      ),
    ),
    TextSpan(text: ' also provides\n'),
    CopyableWidgetSpan(
      index: 6,
      plainText: '`.watch()`',
      child: CodeQuote(child: CodeFunctionCall(name: 'watch')),
    ),
    TextSpan(text: ' and '),
    CopyableWidgetSpan(
      index: 7,
      plainText: '`.watchOnly()`',
      child: CodeQuote(child: CodeFunctionCall(name: 'watchOnly')),
    ),
    TextSpan(text: ' methods to observe the value conveniently.'),
    TextSpan(text: '\n\n'),
    CopyableWidgetSpan(
      index: 8,
      plainText: '`Ref`',
      child: CodeQuote(child: CodeType(type: 'Ref')),
    ),
    TextSpan(text: ' can be bound only to a single value per '),
    CopyableWidgetSpan(
      index: 9,
      plainText: '`BuildContext`',
      child: CodeQuote(child: CodeType(type: 'BuildContext')),
    ),
    TextSpan(text: '. Child contexts can override their parents\' '),
    CopyableWidgetSpan(
      index: 10,
      plainText: '`Ref`',
      child: CodeQuote(child: CodeType(type: 'Ref')),
    ),
    TextSpan(text: ' bindings.'),
    TextSpan(text: '\n\n'),
    CopyableWidgetSpan(
      index: 11,
      plainText: '👋',
      child: Padding(
        padding: EdgeInsets.only(right: 4),
        child: SvgPicture(
          SvgAssetLoader('assets/svg/emoji_u1f44b.svg'), // 👋
          width: 16,
          height: 16,
        ),
      ),
    ),
    TextSpan(text: ' '),
    TextSpan(text: 'Bye, '),
    CopyableWidgetSpan(
      index: 12,
      plainText: '`InheritedWidget`',
      child: CodeQuote(child: CodeType(type: 'InheritedWidget')),
    ),
    TextSpan(text: '!'),
  ],
);

const _bindTitle = TextSpan(
  children: [
    WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: SvgPicture(
          SvgAssetLoader('assets/svg/emoji_u1f91d.svg'), // 🤝
          width: 16,
          height: 16,
        ),
      ),
    ),
    TextSpan(text: '  '),
    WidgetSpan(
      child: CodeQuote(child: CodeFunctionCall(name: 'bind')),
    ),
    TextSpan(text: ' it to a '),
    WidgetSpan(
      child: CodeQuote(child: CodeType(type: 'BuildContext')),
    ),
  ],
);
const _bindDescription = TextSpan(
  children: [
    CopyableWidgetSpan(
      index: 0,
      plainText: '`Ref.bind(context, () => ...)`',
      child: CodeQuote(
        margin: EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CodeType(type: 'Ref'),
            CodeFunctionCall(
              name: 'bind',
              params: [
                CodeParameter(name: 'context'),
                Text('() => ...'),
              ],
            ),
          ],
        ),
      ),
    ),
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Binds a '),
      CopyableWidgetSpan(
        index: 1,
        plainText: '`Ref`',
        child: CodeQuote(child: CodeType(type: 'Ref')),
      ),
      TextSpan(text: ' to the '),
      TextSpan(
        text: 'value initializer',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: '.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Value initialization happens immediately.'),
      TextSpan(text: ' Use '),
      CopyableWidgetSpan(
        index: 2,
        plainText: '`.bindLazy()`',
        child: CodeQuote(child: CodeFunctionCall(name: 'bindLazy')),
      ),
      TextSpan(text: ' if you need it lazy.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Value is '),
      CopyableWidgetSpan(
        index: 3,
        plainText: '`.dispose()`',
        child: CodeQuote(child: CodeFunctionCall(name: 'dispose')),
      ),
      TextSpan(text: '\'d automatically when the widget is disposed.'),
      TextSpan(text: ' Provide a '),
      CopyableWidgetSpan(
        index: 4,
        plainText: '`dispose`',
        child: CodeQuote(child: CodeParameter(name: 'dispose')),
      ),
      TextSpan(text: ' callback to customize the disposal if needed.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Similarly to widgets, '),
      CopyableWidgetSpan(
        index: 5,
        plainText: '`key`',
        child: CodeQuote(child: CodeParameter(name: 'key')),
      ),
      TextSpan(text: ' parameter allows for updating the value initializer when needed.'),
    ],
    TextSpan(text: '\n\n'),
    CopyableWidgetSpan(
      index: 6,
      plainText: '`Ref.bind(context, () => ...)`',
      child: CodeQuote(
        margin: EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CodeType(type: 'Ref'),
            CodeFunctionCall(
              name: 'bindValue',
              params: [
                CodeParameter(name: 'context'),
                Text('...'),
              ],
            ),
          ],
        ),
      ),
    ),
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Binds the '),
      TextSpan(
        text: 'value',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' to the '),
      CopyableWidgetSpan(
        index: 7,
        plainText: '`context`',
        child: CodeQuote(child: CodeParameter(name: 'context')),
      ),
      TextSpan(text: '.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Whenever the value changes, the dependent widgets will be automatically rebuilt.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Values provided this way are '),
      TextSpan(
        text: 'not',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      TextSpan(text: ' disposed automatically.'),
    ],
    TextSpan(text: '\n\n'),
    ...[
      CopyableWidgetSpan(
        index: 8,
        plainText: '👋',
        child: Padding(
          padding: EdgeInsets.only(right: 4),
          child: SvgPicture(
            SvgAssetLoader('assets/svg/emoji_u1f44b.svg'), // 👋
            width: 16,
            height: 16,
          ),
        ),
      ),
      TextSpan(text: ' '),
      TextSpan(text: 'Bye, '),
      CopyableWidgetSpan(
        index: 9,
        plainText: '`StatefulWidget`',
        child: CodeQuote(child: CodeType(type: 'StatefulWidget')),
      ),
      TextSpan(text: '!'),
    ],
  ],
);

const _watchTitle = TextSpan(
  children: [
    WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: SvgPicture(
          SvgAssetLoader('assets/svg/emoji_u1f440.svg'), // 👀
          width: 16,
          height: 16,
        ),
      ),
    ),
    TextSpan(text: '  '),
    WidgetSpan(
      child: CodeQuote(child: CodeFunctionCall(name: 'watch')),
    ),
    TextSpan(text: ' it from a '),
    WidgetSpan(
      child: CodeQuote(child: CodeType(type: 'BuildContext')),
    ),
  ],
);
const _watchDescription = TextSpan(
  children: [
    CopyableWidgetSpan(
      index: 0,
      plainText: '`<Observable>.watch(context)` or `Ref<Observable>.watch(context)`',
      child: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Wrap(
          children: [
            CodeQuote(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeType(type: '{Stream|Future|Listenable|ValueListenable}'),
                  CodeFunctionCall(
                    name: 'watch',
                    params: [CodeParameter(name: 'context')],
                  ),
                ],
              ),
            ),
            Text(' and ', style: TextStyle(height: 1.75)),
            CodeQuote(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CodeType(type: 'Ref', genericTypes: ['{Stream|Future|Listenable|ValueListenable}']),
                  CodeFunctionCall(
                    name: 'watch',
                    params: [CodeParameter(name: 'context')],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Rebuilds the '),
      CopyableWidgetSpan(
        index: 1,
        plainText: '`context`',
        child: CodeQuote(child: CodeParameter(name: 'context')),
      ),
      TextSpan(text: ' whenever the observable value notifies of changes.'),
    ],
    TextSpan(text: '\n'),
    ...[_bulletPoint, TextSpan(text: 'Provides the same data as the corresponding builder widget.')],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'When more granular rebuild control is desired, use '),
      CopyableWidgetSpan(
        index: 2,
        plainText: '`.watchOnly(context)`',
        child: CodeQuote(child: CodeFunctionCall(name: 'watchOnly')),
      ),
      TextSpan(text: ', which rebuilds the widget only if the selected value changes.'),
    ],
    TextSpan(text: '\n'),
    ...[
      _bulletPoint,
      TextSpan(text: 'Use '),
      CopyableWidgetSpan(
        index: 2,
        plainText: '`.watchEffect(context, ...)`',
        child: CodeQuote(child: CodeFunctionCall(name: 'watchEffect')),
      ),
      TextSpan(text: " to register a callback for a value change, which never triggers a rebuild."),
    ],
    TextSpan(text: '\n\n'),
    ...[
      CopyableWidgetSpan(
        index: 3,
        plainText: '👋',
        child: Padding(
          padding: EdgeInsets.only(right: 4),
          child: SvgPicture(
            SvgAssetLoader('assets/svg/emoji_u1f44b.svg'), // 👋
            width: 16,
            height: 16,
          ),
        ),
      ),
      TextSpan(text: ' '),
      TextSpan(text: 'Bye, '),
      CopyableWidgetSpan(
        index: 4,
        plainText: '`<Observable>Builder`',
        child: CodeQuote(child: CodeType(type: '{Stream|Future|Listenable|ValueListenable}Builder')),
      ),
      TextSpan(text: '!'),
    ],
  ],
);

const _bulletPoint = TextSpan(
  text: '• ',
  style: TextStyle(fontWeight: FontWeight.bold),
);

class _Title extends StatelessWidget {
  const _Title({required this.step, required this.isMobileLayout});

  final int step;
  final bool isMobileLayout;

  @override
  Widget build(BuildContext context) {
    const turnsTween = ConstTween<double>(begin: 0, end: 1 / 2);

    final expandCtrl = _mobileExpandCtrl.of(context);
    final isExpanded = expandCtrl?.watchOnly(context, (value) => value > 0.5);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (isMobileLayout && expandCtrl != null) {
          expandCtrl.isDismissed ? expandCtrl.forward() : expandCtrl.reverse();
          return;
        }

        final codeAnimCtrl = _codeAnimCtrl.of(context);
        codeAnimCtrl.animateToStep(step);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                child: Text.rich(_titles[step]!),
              ),
            ),
            if (isMobileLayout) ...[
              const Gap(8),
              RotationTransition(
                turns: turnsTween.animate(expandCtrl!),
                child: SvgIcon(
                  isExpanded! ? 'assets/svg/icon_arrow_collapse.svg' : 'assets/svg/icon_arrow_expand.svg',
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Gap(10),
            ],
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    const opacityCurve = Curves.easeIn;

    final codeAnimCtrl = _codeAnimCtrl.of(context);

    return ClipRect(
      child: AnimatedBuilder(
        animation: codeAnimCtrl,
        builder: (context, child) {
          final stepProgress = codeAnimCtrl.stepProgress(step);
          return Align(
            alignment: Alignment.topLeft,
            widthFactor: 1,
            heightFactor: stepProgress,
            child: Opacity(
              opacity: opacityCurve.transform(stepProgress),
              child: TickerMode(enabled: stepProgress >= 0.9, child: child!),
            ),
          );
        },
        child: LowEmphasisCard(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[300]),
              child: Text.rich(_descriptions[step]!),
            ),
          ),
        ),
      ),
    );
  }
}
