import 'dart:math' as math;

import 'package:example/other/hooks/anim_hooks.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A [Flex]-like widget that animates reversing the visual order of its
/// children.
///
/// When the provided [animation] runs from `0` to `1`, each child slides to the
/// position that the mirrored child would occupy if the children list were
/// reversed. This is implemented with a custom render object so no additional
/// widgets are required around the children.
class ReverseFlexTransition extends Flex {
  const ReverseFlexTransition({
    super.key,
    required this.animation,
    this.interval,
    this.curveOffset = 0.3,
    required super.direction,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.textDirection,
    super.verticalDirection = VerticalDirection.down,
    super.textBaseline,
    super.clipBehavior = Clip.none,
    super.spacing = 0.0,
    super.children,
  }) : assert(
         !identical(crossAxisAlignment, CrossAxisAlignment.baseline) || textBaseline != null,
         'textBaseline is required if you specify the crossAxisAlignment with '
         'CrossAxisAlignment.baseline',
       );

  final Animation<double> animation;
  final (double begin, double end)? interval;
  final double curveOffset;

  Animation<double> _anim(BuildContext context) {
    if (interval != null) {
      return context.useIntervalAnimation(animation, interval!);
    }
    return animation;
  }

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _RenderReverseFlexTransition(
      animation: _anim(context),
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
      curveOffset: curveOffset,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    // ignore: library_private_types_in_public_api
    covariant _RenderReverseFlexTransition renderObject,
  ) {
    renderObject
      ..animation = _anim(context)
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..mainAxisSize = mainAxisSize
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..verticalDirection = verticalDirection
      ..textBaseline = textBaseline
      ..clipBehavior = clipBehavior
      ..spacing = spacing
      ..curveOffset = curveOffset;
  }
}

class _RenderReverseFlexTransition extends RenderFlex {
  _RenderReverseFlexTransition({
    required Animation<double> animation,
    required super.direction,
    required super.mainAxisAlignment,
    required super.mainAxisSize,
    required super.crossAxisAlignment,
    required TextDirection? textDirection,
    required super.verticalDirection,
    required super.textBaseline,
    required super.clipBehavior,
    required super.spacing,
    required double curveOffset,
  }) : _animation = animation,
       _curveOffset = curveOffset {
    this.textDirection = textDirection;
    _animation.addListener(_handleAnimationChanged);
  }

  Animation<double> _animation;
  double _curveOffset;
  set curveOffset(double value) {
    if (_curveOffset == value) return;
    _curveOffset = value;
    markNeedsLayout();
  }

  set animation(Animation<double> value) {
    if (_animation == value) return;
    _animation.removeListener(_handleAnimationChanged);
    _animation = value;
    _animation.addListener(_handleAnimationChanged);
    markNeedsLayout();
  }

  final List<RenderBox> _visualChildren = <RenderBox>[];
  final Map<RenderBox, Offset> _forwardOffsets = <RenderBox, Offset>{};
  final Map<RenderBox, Offset> _reverseOffsets = <RenderBox, Offset>{};
  double? _mainAxisLeading; // Smallest main-axis coordinate among children.
  double? _mainAxisTrailing; // Largest trailing edge among children.

  double get _animationValue => _animation.value.clamp(0.0, 1.0);

  void _handleAnimationChanged() {
    if (!attached) return;
    markNeedsLayout();
  }

  bool get _shouldFlipMainAxis {
    switch (direction) {
      case Axis.horizontal:
        return textDirection == TextDirection.rtl;
      case Axis.vertical:
        return verticalDirection == VerticalDirection.up;
    }
  }

  @override
  void performLayout() {
    super.performLayout();
    _recomputeChildOffsets();
    _applyAnimatedOffsets();
  }

  void _recomputeChildOffsets() {
    _visualChildren.clear();
    _forwardOffsets.clear();
    _reverseOffsets.clear();
    _mainAxisLeading = null;
    _mainAxisTrailing = null;

    if (childCount == 0) {
      return;
    }

    final bool flip = _shouldFlipMainAxis;
    RenderBox? child = flip ? lastChild : firstChild;
    final RenderBox? Function(RenderBox child) nextChild = flip ? childBefore : childAfter;

    while (child != null) {
      _visualChildren.add(child);
      child = nextChild(child);
    }

    if (_visualChildren.isEmpty) {
      return;
    }

    for (final child in _visualChildren) {
      final FlexParentData parentData = child.parentData! as FlexParentData;
      _forwardOffsets[child] = parentData.offset;
      final double mainStart = _mainAxisFromOffset(parentData.offset);
      final double mainEnd = mainStart + _mainAxisExtent(child.size);
      _mainAxisLeading = _mainAxisLeading == null ? mainStart : math.min(_mainAxisLeading!, mainStart);
      _mainAxisTrailing = _mainAxisTrailing == null ? mainEnd : math.max(_mainAxisTrailing!, mainEnd);
    }

    final double leading = _mainAxisLeading ?? 0.0;
    final double trailing = _mainAxisTrailing ?? leading;
    final double totalSpan = trailing - leading;

    for (final child in _visualChildren) {
      final Offset forwardOffset = _forwardOffsets[child]!;
      final double mainStart = _mainAxisFromOffset(forwardOffset);
      final double crossStart = _crossAxisFromOffset(forwardOffset);
      final double mainSize = _mainAxisExtent(child.size);
      final double relativeStart = mainStart - leading;
      final double mirroredStart = leading + (totalSpan - mainSize - relativeStart);
      _reverseOffsets[child] = _offsetFromMainCross(mirroredStart, crossStart);
    }
  }

  Offset _currentChildOffset(RenderBox child) {
    final Offset? forward = _forwardOffsets[child];
    final Offset? reverse = _reverseOffsets[child];
    if (forward == null || reverse == null) {
      final FlexParentData parentData = child.parentData! as FlexParentData;
      return parentData.offset;
    }

    // Linear interpolation for main position
    final Offset linearOffset = Offset.lerp(forward, reverse, _animationValue) ?? forward;

    // Calculate curve offset for perpendicular movement
    // Use sine curve that peaks at midpoint (0.5) and returns to 0 at start/end
    final double curveProgress = _animationValue;
    final double curveHeight = math.sin(curveProgress * math.pi);

    // Determine which direction to curve based on swap direction
    final int childIndex = _visualChildren.indexOf(child);
    final int totalChildren = _visualChildren.length;
    final int mirroredIndex = totalChildren - 1 - childIndex;

    // Children moving forward (left->right or top->bottom) curve one way,
    // children moving backward (right->left or bottom->top) curve opposite
    final bool isMovingForward = childIndex < mirroredIndex;
    final double curveDirection = isMovingForward ? 1.0 : -1.0;

    // Calculate the distance being traveled for arc height scaling
    final double mainAxisDistance = (_mainAxisFromOffset(reverse) - _mainAxisFromOffset(forward)).abs();
    final double arcHeight = mainAxisDistance * _curveOffset * curveHeight * curveDirection;

    // Apply perpendicular offset based on direction
    final double crossAxisOffset = switch (direction) {
      Axis.horizontal => arcHeight,
      Axis.vertical => -arcHeight, // Invert for vertical since we want left/right curve
    };

    return _offsetFromMainCross(
      _mainAxisFromOffset(linearOffset),
      _crossAxisFromOffset(linearOffset) + crossAxisOffset,
    );
  }

  double _mainAxisFromOffset(Offset offset) {
    return switch (direction) {
      Axis.horizontal => offset.dx,
      Axis.vertical => offset.dy,
    };
  }

  double _crossAxisFromOffset(Offset offset) {
    return switch (direction) {
      Axis.horizontal => offset.dy,
      Axis.vertical => offset.dx,
    };
  }

  Offset _offsetFromMainCross(double main, double cross) {
    return switch (direction) {
      Axis.horizontal => Offset(main, cross),
      Axis.vertical => Offset(cross, main),
    };
  }

  double _mainAxisExtent(Size size) {
    return switch (direction) {
      Axis.horizontal => size.width,
      Axis.vertical => size.height,
    };
  }

  void _applyAnimatedOffsets() {
    if (_visualChildren.isEmpty) {
      return;
    }
    for (final child in _visualChildren) {
      final FlexParentData parentData = child.parentData! as FlexParentData;
      parentData.offset = _currentChildOffset(child);
    }
  }

  @override
  void dispose() {
    _animation.removeListener(_handleAnimationChanged);
    super.dispose();
  }
}
