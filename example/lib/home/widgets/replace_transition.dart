import 'dart:math' as math;

import 'package:example/other/hooks/anim_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReplaceTransition extends StatelessWidget {
  const ReplaceTransition({
    super.key,
    required this.animation,
    this.interval,
    required this.prevChild,
    required this.child,
  });

  final Animation<double> animation;
  final (double begin, double end)? interval;
  final Widget prevChild;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Animation<double> anim = animation;
    if (interval != null) {
      anim = context.useIntervalAnimation(animation, interval!);
    }

    return RepaintBoundary(
      child: UnconstrainedBox(
        child: _ReplaceTransitionRenderObjectWidget(
          animation: anim,
          prevPositionAnim: context.useOffsetTweenAnimation(key: 'prevPositionAnim', anim, tween: ((0, 0), (0, -1))),
          prevOpacityAnim: context.useDoubleTweenAnimation(
            key: 'prevOpacityAnim',
            anim,
            tween: (1, 0),
            interval: (0, 0.75),
          ),
          currentPositionAnim: context.useOffsetTweenAnimation(
            key: 'currentPositionAnim',
            anim,
            tween: ((0, 1), (0, 0)),
          ),
          currentOpacityAnim: context.useDoubleTweenAnimation(
            key: 'currentOpacityAnim',
            anim,
            tween: (0, 1),
            interval: (0.25, 1),
          ),
          prevChild: prevChild,
          child: child,
        ),
      ),
    );
  }
}

class _ReplaceTransitionRenderObjectWidget extends MultiChildRenderObjectWidget {
  _ReplaceTransitionRenderObjectWidget({
    required this.animation,
    required this.prevPositionAnim,
    required this.prevOpacityAnim,
    required this.currentPositionAnim,
    required this.currentOpacityAnim,
    required this.prevChild,
    required this.child,
  }) : super(children: [prevChild, child]);

  final Animation<double> animation;
  final Animation<Offset> prevPositionAnim;
  final Animation<double> prevOpacityAnim;
  final Animation<Offset> currentPositionAnim;
  final Animation<double> currentOpacityAnim;
  final Widget prevChild;
  final Widget child;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ReplaceTransitionRenderBox(
      animation: animation,
      prevPositionAnim: prevPositionAnim,
      prevOpacityAnim: prevOpacityAnim,
      currentPositionAnim: currentPositionAnim,
      currentOpacityAnim: currentOpacityAnim,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _ReplaceTransitionRenderBox renderObject) {
    renderObject
      ..animation = animation
      ..prevPositionAnim = prevPositionAnim
      ..prevOpacityAnim = prevOpacityAnim
      ..currentPositionAnim = currentPositionAnim
      ..currentOpacityAnim = currentOpacityAnim;
  }
}

class _ReplaceTransitionParentData extends ContainerBoxParentData<RenderBox> {}

typedef _ChildPair = ({RenderBox prev, RenderBox current});

class _ReplaceTransitionRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ReplaceTransitionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ReplaceTransitionParentData> {
  _ReplaceTransitionRenderBox({
    required Animation<double> animation,
    required Animation<Offset> prevPositionAnim,
    required Animation<double> prevOpacityAnim,
    required Animation<Offset> currentPositionAnim,
    required Animation<double> currentOpacityAnim,
  }) : _animation = animation,
       _prevPositionAnim = prevPositionAnim,
       _prevOpacityAnim = prevOpacityAnim,
       _currentPositionAnim = currentPositionAnim,
       _currentOpacityAnim = currentOpacityAnim {
    _animation.addListener(_markNeedsLayout);
    for (final animation in _paintAnimations) {
      animation.addListener(_markNeedsPaint);
    }
    _prevSize = Size.zero;
    _currentSize = Size.zero;
  }

  Iterable<Listenable> get _paintAnimations => <Listenable>[
    _prevPositionAnim,
    _prevOpacityAnim,
    _currentPositionAnim,
    _currentOpacityAnim,
  ];

  Animation<double> _animation;
  Animation<double> get animation => _animation;
  set animation(Animation<double> value) {
    if (_animation == value) return;
    _animation.removeListener(_markNeedsLayout);
    _animation = value;
    _animation.addListener(_markNeedsLayout);
    markNeedsLayout();
  }

  Animation<Offset> _prevPositionAnim;
  Animation<Offset> get prevPositionAnim => _prevPositionAnim;
  set prevPositionAnim(Animation<Offset> value) {
    _prevPositionAnim = _replacePaintAnimation(_prevPositionAnim, value);
  }

  Animation<double> _prevOpacityAnim;
  Animation<double> get prevOpacityAnim => _prevOpacityAnim;
  set prevOpacityAnim(Animation<double> value) {
    _prevOpacityAnim = _replacePaintAnimation(_prevOpacityAnim, value);
  }

  Animation<Offset> _currentPositionAnim;
  Animation<Offset> get currentPositionAnim => _currentPositionAnim;
  set currentPositionAnim(Animation<Offset> value) {
    _currentPositionAnim = _replacePaintAnimation(_currentPositionAnim, value);
  }

  Animation<double> _currentOpacityAnim;
  Animation<double> get currentOpacityAnim => _currentOpacityAnim;
  set currentOpacityAnim(Animation<double> value) {
    _currentOpacityAnim = _replacePaintAnimation(_currentOpacityAnim, value);
  }

  T _replacePaintAnimation<T extends Listenable>(T current, T next) {
    if (identical(current, next)) return current;
    current.removeListener(_markNeedsPaint);
    next.addListener(_markNeedsPaint);
    markNeedsPaint();
    return next;
  }

  Size _prevSize = Size.zero;
  Size _currentSize = Size.zero;

  void _markNeedsLayout() => markNeedsLayout();
  void _markNeedsPaint() => markNeedsPaint();

  _ChildPair? get _pair {
    final prev = firstChild;
    if (prev == null) return null;
    final current = childAfter(prev);
    if (current == null) return null;
    return (prev: prev, current: current);
  }

  _ReplaceTransitionParentData _parentDataOf(RenderBox child) {
    return child.parentData! as _ReplaceTransitionParentData;
  }

  Offset _fractionalOffsetToPixels(Offset fractional, Size size) {
    return Offset(fractional.dx * size.width, fractional.dy * size.height);
  }

  void _paintSlidingChild({
    required PaintingContext context,
    required RenderBox child,
    required Offset parentOffset,
    required Offset fractionalOffset,
    required Size childSize,
    required double opacity,
  }) {
    final alpha = (opacity.clamp(0.0, 1.0) * 255).round();
    if (alpha <= 0) return;
    final childOffset = parentOffset + _fractionalOffsetToPixels(fractionalOffset, childSize);
    context.pushOpacity(childOffset, alpha, (context, offset) => context.paintChild(child, offset));
  }

  Size _lerpSize(Size a, Size b) => Size.lerp(a, b, _animation.value) ?? Size.zero;

  double _maxIntrinsicValue(double extent, double Function(RenderBox child, double extent) measure) {
    var value = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      value = math.max(value, measure(child, extent));
      child = childAfter(child);
    }
    return value;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ReplaceTransitionParentData) {
      child.parentData = _ReplaceTransitionParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (childCount == 0) return 0.0;
    return _maxIntrinsicValue(height, (child, extent) => child.getMinIntrinsicWidth(extent));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (childCount == 0) return 0.0;
    return _maxIntrinsicValue(height, (child, extent) => child.getMaxIntrinsicWidth(extent));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childCount == 0) return 0.0;
    return _maxIntrinsicValue(width, (child, extent) => child.getMinIntrinsicHeight(extent));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) return 0.0;
    return _maxIntrinsicValue(width, (child, extent) => child.getMaxIntrinsicHeight(extent));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final pair = _pair;
    if (pair == null) return constraints.smallest;

    final prevSize = pair.prev.getDryLayout(constraints);
    final currentSize = pair.current.getDryLayout(constraints);

    return constraints.constrain(_lerpSize(prevSize, currentSize));
  }

  @override
  void performLayout() {
    final pair = _pair;
    if (pair == null) {
      size = constraints.smallest;
      return;
    }

    final prev = pair.prev;
    final current = pair.current;

    prev.layout(constraints, parentUsesSize: true);
    current.layout(constraints, parentUsesSize: true);

    _prevSize = prev.size;
    _currentSize = current.size;

    size = constraints.constrain(_lerpSize(_prevSize, _currentSize));

    _parentDataOf(prev).offset = Offset.zero;
    _parentDataOf(current).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final pair = _pair;
    if (pair == null) return;

    final prevParentOffset = offset + _parentDataOf(pair.prev).offset;
    _paintSlidingChild(
      context: context,
      child: pair.prev,
      parentOffset: prevParentOffset,
      fractionalOffset: _prevPositionAnim.value,
      childSize: _prevSize,
      opacity: _prevOpacityAnim.value,
    );

    final currentParentOffset = offset + _parentDataOf(pair.current).offset;
    _paintSlidingChild(
      context: context,
      child: pair.current,
      parentOffset: currentParentOffset,
      fractionalOffset: _currentPositionAnim.value,
      childSize: _currentSize,
      opacity: _currentOpacityAnim.value,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final pair = _pair;
    if (pair == null) return false;

    bool hit(RenderBox child, _ReplaceTransitionParentData parentData, Offset fractionalOffset, Size childSize) {
      final animatedOffset = parentData.offset + _fractionalOffsetToPixels(fractionalOffset, childSize);
      return child.hitTest(BoxHitTestResult.wrap(result), position: position - animatedOffset);
    }

    final currentParentData = _parentDataOf(pair.current);
    if (hit(pair.current, currentParentData, _currentPositionAnim.value, _currentSize)) {
      return true;
    }

    final prevParentData = _parentDataOf(pair.prev);
    return hit(pair.prev, prevParentData, _prevPositionAnim.value, _prevSize);
  }

  @override
  void dispose() {
    _animation.removeListener(_markNeedsLayout);
    for (final animation in _paintAnimations) {
      animation.removeListener(_markNeedsPaint);
    }
    super.dispose();
  }
}
