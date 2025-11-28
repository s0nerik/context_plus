import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver that takes up [viewport] + [extraViewports] * [viewport] height and constrains its child to viewport height.
///
/// The child is fully visible when scroll offset is 0 to [extraViewports] * [viewport], and scrolls away
/// when scroll offset changes from [extraViewports] * [viewport] to ([extraViewports] + 1) * [viewport].
class SliverExtraExtentViewport extends SingleChildRenderObjectWidget {
  const SliverExtraExtentViewport({
    super.key,
    required this.viewport,
    this.extraViewports = 1.0,
    required super.child,
  });

  final double viewport;
  final double extraViewports;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverExtraExtentViewport(viewport: viewport, extraViewports: extraViewports);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSliverExtraExtentViewport renderObject) {
    renderObject.viewport = viewport;
    renderObject.extraViewports = extraViewports;
  }
}

class RenderSliverExtraExtentViewport extends RenderSliver with RenderObjectWithChildMixin<RenderBox> {
  RenderSliverExtraExtentViewport({required double viewport, double extraViewports = 1.0})
    : _viewport = viewport,
      _extraViewports = extraViewports;

  double _viewport;
  double get viewport => _viewport;
  set viewport(double value) {
    if (_viewport != value) {
      _viewport = value;
      markNeedsLayout();
    }
  }

  double _extraViewports;
  double get extraViewports => _extraViewports;
  set extraViewports(double value) {
    if (_extraViewports != value) {
      _extraViewports = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final double viewportHeight = viewport;
    final double totalExtent = viewportHeight + extraViewports * viewportHeight;
    final double scrollAwayStart = extraViewports * viewportHeight;

    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    // Layout child with viewport height constraint
    final BoxConstraints childConstraints = constraints.asBoxConstraints(
      minExtent: viewportHeight,
      maxExtent: viewportHeight,
    );
    child!.layout(childConstraints, parentUsesSize: true);

    final double scrollOffset = constraints.scrollOffset;
    final double remainingExtent = constraints.remainingCacheExtent;

    // Calculate the paint offset based on scroll position
    double paintOffset = 0.0;

    if (scrollOffset < scrollAwayStart) {
      // Child is fully visible, positioned at the top
      paintOffset = 0.0;
    } else if (scrollOffset < totalExtent) {
      // Child is scrolling away
      final double scrollProgress = (scrollOffset - scrollAwayStart) / viewportHeight;
      paintOffset = -scrollProgress * viewportHeight;
    } else {
      // Scrolled past, child is fully off-screen
      paintOffset = -viewportHeight;
    }

    // Calculate visible extent - how much of the sliver is visible in the viewport
    double paintExtent = 0.0;
    if (scrollOffset < totalExtent) {
      // The sliver occupies space from scrollOffset to totalExtent
      // But we only show up to viewportHeight of it
      paintExtent = (totalExtent - scrollOffset).clamp(0.0, viewportHeight);
    }

    final double cacheExtent = remainingExtent;
    final double maxPaintExtent = viewportHeight;

    geometry = SliverGeometry(
      scrollExtent: totalExtent,
      paintExtent: paintExtent.clamp(0.0, maxPaintExtent),
      cacheExtent: cacheExtent,
      maxPaintExtent: maxPaintExtent,
      hasVisualOverflow: scrollOffset > scrollAwayStart && scrollOffset < totalExtent,
    );

    // Store paint offset for use in paint method
    _paintOffset = paintOffset;
  }

  double _paintOffset = 0.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }

    final SliverGeometry? currentGeometry = geometry;
    if (currentGeometry == null || currentGeometry.paintExtent <= 0) {
      return;
    }

    final Offset childOffset = offset + Offset(0.0, _paintOffset);
    context.paintChild(child!, childOffset);
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double crossAxisPosition,
    required double mainAxisPosition,
  }) {
    if (child == null) {
      return false;
    }

    final SliverGeometry? currentGeometry = geometry;
    if (currentGeometry == null || currentGeometry.paintExtent <= 0) {
      return false;
    }

    final double childMainAxisPosition = mainAxisPosition - _paintOffset;
    if (childMainAxisPosition < 0 || childMainAxisPosition > viewport) {
      return false;
    }

    final bool hitChild = child!.hitTest(
      BoxHitTestResult.wrap(result),
      position: Offset(crossAxisPosition, childMainAxisPosition),
    );

    if (hitChild) {
      result.add(SliverHitTestEntry(this, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition));
    }

    return hitChild;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    if (child != this.child) {
      return;
    }
    transform.translateByDouble(0, -_paintOffset, 0, 1);
  }
}

