import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import 'animated_replace.dart';

final _animate = Ref<bool>();

class DynamicSectionText extends StatelessWidget {
  const DynamicSectionText(
    this.text, {
    super.key,
    this.animate = true,
  });

  /// The text to display.
  ///
  /// Sections enclosed in curly braces will be animated.
  /// Example: 'Hello, {World|Universe}!'
  final String text;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    _animate.bindValue(context, animate);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final section in _getSections(context, value: text))
          switch (section) {
            _StaticSection(:final value) => Text(value),
            _DynamicSection(:final current, :final next) => AnimatedReplace(
                duration: _dynamicSectionTransitionDuration,
                prevChild: Text(
                  key: ValueKey(current),
                  current,
                ),
                child: Text(
                  key: ValueKey(next),
                  next,
                ),
              ),
          }
      ],
    );
  }
}

/// (< end of static section >, < start of next static section >)
final _staticSectionBounds = Ref<(int, int)?>();
final _dynamicSectionVariants = Ref<List<String>>();
final _dynamicSectionAnimCtrl = Ref<AnimationController>();
final _dynamicSectionIndex = Ref<ValueNotifier<int>>();
const _dynamicSectionTransitionDuration = Duration(milliseconds: 500);
const _dynamicSectionChangeInterval = Duration(seconds: 1);

List<_Section> _getSections(
  BuildContext context, {
  required String value,
}) {
  final staticSectionBounds = _staticSectionBounds.bind(context, () {
    final startDynamic = value.indexOf('{');
    final endDynamic = value.lastIndexOf('}');
    if (startDynamic == -1 || endDynamic == -1) {
      return null;
    }
    return (startDynamic, endDynamic + 1);
  }, key: value);

  final dynamicSectionVariants = _dynamicSectionVariants.bind(context, () {
    if (staticSectionBounds == null) {
      return const [];
    }
    return value
        .substring(staticSectionBounds.$1 + 1, staticSectionBounds.$2 - 1)
        .split('|');
  }, key: value);

  if (staticSectionBounds != null && dynamicSectionVariants.isNotEmpty) {
    final (staticSection1, staticSection2) = (
      value.substring(0, staticSectionBounds.$1),
      value.substring(staticSectionBounds.$2),
    );

    final dynamicSectionIndex =
        _dynamicSectionIndex.bind(context, () => ValueNotifier(0), key: value);
    _dynamicSectionAnimCtrl.bind(context, (vsync) {
      final ctrl = AnimationController(
        vsync: vsync,
        duration: _dynamicSectionChangeInterval,
      );
      return ctrl
        ..forward()
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (_animate.of(context)) {
              dynamicSectionIndex.value += 1;
            }
            ctrl.forward(from: 0);
          }
        });
    }, key: value);

    final currentDynamicSection = dynamicSectionVariants[
        dynamicSectionIndex.watch(context) % dynamicSectionVariants.length];
    final nextDynamicSection = dynamicSectionVariants[
        (dynamicSectionIndex.watch(context) + 1) %
            dynamicSectionVariants.length];
    return [
      _StaticSection(value: staticSection1),
      _DynamicSection(
        variants: dynamicSectionVariants,
        current: currentDynamicSection,
        next: nextDynamicSection,
      ),
      _StaticSection(value: staticSection2),
    ];
  }
  return [
    _StaticSection(value: value),
  ];
}

sealed class _Section {}

class _StaticSection extends _Section {
  _StaticSection({required this.value});

  final String value;
}

class _DynamicSection extends _Section {
  _DynamicSection({
    required this.variants,
    required this.current,
    required this.next,
  });

  final List<String> variants;
  final String current;
  final String next;
}
