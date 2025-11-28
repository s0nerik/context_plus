import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A decoration that draws a glowing gradient border around a box.
///
/// The glow smoothly interpolates between the provided colors, rotating
/// around the box perimeter based on the [rotation] parameter.
class GradientGlowDecoration extends Decoration {
  /// Creates a gradient glow decoration.
  ///
  /// [colors] must not be empty. The glow will interpolate between these
  /// colors as it travels around the box perimeter.
  ///
  /// [opacity] controls the opacity of the glow effect.
  /// Typical values range from 0.0 to 1.0, with higher values creating
  /// a more visible glow.
  ///
  /// [rotation] specifies the rotation offset in radians. A value of 0
  /// starts the gradient at the top center of the box.
  ///
  /// [borderRadius] controls the corner radius of the rounded rectangle.
  ///
  /// [blurRadius] controls the blur radius of the glow effect. If not provided,
  /// it will be calculated from [opacity] (opacity * 20.0).
  ///
  /// [borderWidth] controls the stroke width of the border paint.
  ///
  /// [borderOpacity] controls the opacity of the border paint.
  /// Typical values range from 0.0 to 1.0.
  ///
  /// [backgroundColor] controls the background color of the box.
  GradientGlowDecoration({
    required this.colors,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.borderRadius = BorderRadius.zero,
    this.blurRadius = 24,
    this.borderWidth = 8.0,
    this.borderOpacity = 1.0,
    this.backgroundColor,
  }) : assert(colors.isNotEmpty, 'Colors list must not be empty');

  /// The list of colors to interpolate between.
  final List<Color> colors;

  /// The opacity of the glow effect (0.0 to 1.0).
  final double opacity;

  /// The rotation offset in radians.
  final double rotation;

  /// The border radius for rounded corners.
  final BorderRadius borderRadius;

  /// The blur radius of the glow effect. If null, calculated from [opacity].
  final double blurRadius;

  /// The stroke width of the border paint.
  final double borderWidth;

  /// The opacity of the border paint (0.0 to 1.0).
  final double borderOpacity;

  /// The background color of the box.
  final Color? backgroundColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientGlowPainter(
      colors: colors,
      opacity: opacity,
      rotation: rotation,
      borderRadius: borderRadius,
      blurRadius: blurRadius,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      backgroundColor: backgroundColor,
    );
  }

  @override
  GradientGlowDecoration lerpFrom(Decoration? a, double t) {
    if (a is! GradientGlowDecoration) {
      return GradientGlowDecoration(
        colors: colors,
        opacity: opacity * t,
        rotation: rotation,
        borderRadius: borderRadius,
        blurRadius: blurRadius * t,
        borderWidth: borderWidth,
        borderOpacity: borderOpacity * t,
        backgroundColor: backgroundColor,
      );
    }

    // Interpolate opacity and rotation
    final lerpedOpacity = ui.lerpDouble(a.opacity, opacity, t) ?? opacity;
    final lerpedRotation = ui.lerpDouble(a.rotation, rotation, t) ?? rotation;
    final lerpedBlurRadius = ui.lerpDouble(a.blurRadius, blurRadius, t) ?? blurRadius;
    final lerpedBorderWidth = ui.lerpDouble(a.borderWidth, borderWidth, t) ?? borderWidth;
    final lerpedBorderOpacity = ui.lerpDouble(a.borderOpacity, borderOpacity, t) ?? borderOpacity;

    // For colors, use the longer list and interpolate
    final maxLength = math.max(a.colors.length, colors.length);
    final lerpedColors = List<Color>.generate(maxLength, (i) {
      final colorA = a.colors[i % a.colors.length];
      final colorB = colors[i % colors.length];
      return Color.lerp(colorA, colorB, t) ?? colorB;
    });

    final lerpedBackgroundColor = backgroundColor != null && a.backgroundColor != null
        ? Color.lerp(a.backgroundColor, backgroundColor, t)
        : (t < 0.5 ? a.backgroundColor : backgroundColor);

    return GradientGlowDecoration(
      colors: lerpedColors,
      opacity: lerpedOpacity,
      rotation: lerpedRotation,
      borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t) ?? borderRadius,
      blurRadius: lerpedBlurRadius,
      borderWidth: lerpedBorderWidth,
      borderOpacity: lerpedBorderOpacity,
      backgroundColor: lerpedBackgroundColor,
    );
  }

  @override
  GradientGlowDecoration lerpTo(Decoration? b, double t) {
    if (b is! GradientGlowDecoration) {
      return GradientGlowDecoration(
        colors: colors,
        opacity: opacity * (1 - t),
        rotation: rotation,
        borderRadius: borderRadius,
        blurRadius: blurRadius * (1 - t),
        borderWidth: borderWidth,
        borderOpacity: borderOpacity * (1 - t),
        backgroundColor: backgroundColor,
      );
    }
    return b.lerpFrom(this, t);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradientGlowDecoration &&
        listEquals(other.colors, colors) &&
        other.opacity == opacity &&
        other.rotation == rotation &&
        other.borderRadius == borderRadius &&
        other.blurRadius == blurRadius &&
        other.borderWidth == borderWidth &&
        other.borderOpacity == borderOpacity &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(colors),
      opacity,
      rotation,
      borderRadius,
      blurRadius,
      borderWidth,
      borderOpacity,
      backgroundColor,
    );
  }
}

class _GradientGlowPainter extends BoxPainter {
  _GradientGlowPainter({
    required this.colors,
    required this.opacity,
    required this.rotation,
    required this.borderRadius,
    required this.blurRadius,
    required this.borderWidth,
    required this.borderOpacity,
    this.backgroundColor,
  });

  final List<Color> colors;
  final double opacity;
  final double rotation;
  final BorderRadius borderRadius;
  final double blurRadius;
  final double borderWidth;
  final double borderOpacity;
  final Color? backgroundColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size ?? Size.zero;
    if (size.isEmpty) return;

    final rect = offset & size;
    final rrect = borderRadius.toRRect(rect);

    // Draw background if provided
    if (backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = backgroundColor!
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, backgroundPaint);
    }

    // Blur radius based on opacity or provided value
    final effectiveBlurRadius = blurRadius;
    final strokeWidth = effectiveBlurRadius * 0.6;

    // Create an outer RRect offset outward for the glow path
    final glowOffset = effectiveBlurRadius * 0.3;
    final outerRect = rect.inflate(glowOffset);
    final outerRrect = borderRadius.toRRect(outerRect);

    // Create gradient shader that rotates around the shape
    // Calculate center relative to canvas origin (before any clipping)
    final center = rect.center;
    final bounds = outerRect.inflate(effectiveBlurRadius * 2);

    // Create a sweep gradient centered on the shape
    // We'll use a custom shader that maps angle to color
    final gradient = _createRotatingGradient(center, bounds, rotation);

    // Save canvas state
    canvas.save();

    // Clip to exclude the interior of the container
    final outerClipRect = Rect.fromLTWH(-10000, -10000, 20000, 20000);
    final outerClipPath = Path()..addRect(outerClipRect);
    final innerClipPath = Path()..addRRect(rrect);
    final clipPath = Path.combine(PathOperation.difference, outerClipPath, innerClipPath);
    canvas.clipPath(clipPath, doAntiAlias: false);

    // Create the glow path (outer perimeter)
    final glowPath = Path()..addRRect(outerRrect);

    // Draw the glow with gradient and blur
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, effectiveBlurRadius);

    canvas.drawPath(glowPath, paint);

    // Draw a thin border line with borderOpacity
    final borderPath = Path()..addRRect(rrect);
    final borderGradient = _createRotatingGradient(center, bounds, rotation, effectiveOpacity: borderOpacity);
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = borderGradient;

    canvas.drawPath(borderPath, borderPaint);

    // Restore canvas state
    canvas.restore();
  }

  /// Creates a gradient shader that rotates around a center point.
  ui.Gradient _createRotatingGradient(Offset center, Rect bounds, double rotation, {double? effectiveOpacity}) {
    // Create color stops for the gradient
    // We need to map the angle around the shape to colors
    final colorStops = <double>[];
    final gradientColors = <Color>[];

    // Generate color stops based on the number of colors
    // Apply opacity to colors (use provided effectiveOpacity or default to opacity)
    final opacityToUse = effectiveOpacity ?? opacity;

    // Use Catmull-Rom spline for smooth color transition
    const samplesPerSegment = 8;
    final n = colors.length;

    double catmullRom(double p0, double p1, double p2, double p3, double t) {
      return 0.5 *
          ((2 * p1) +
              (-p0 + p2) * t +
              (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t +
              (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t);
    }

    for (var i = 0; i < n; i++) {
      final p0 = colors[(i - 1 + n) % n];
      final p1 = colors[i];
      final p2 = colors[(i + 1) % n];
      final p3 = colors[(i + 2) % n];

      for (var j = 0; j < samplesPerSegment; j++) {
        final t = j / samplesPerSegment;
        colorStops.add((i + t) / n);

        final r = catmullRom(p0.r, p1.r, p2.r, p3.r, t).clamp(0.0, 1.0);
        final g = catmullRom(p0.g, p1.g, p2.g, p3.g, t).clamp(0.0, 1.0);
        final b = catmullRom(p0.b, p1.b, p2.b, p3.b, t).clamp(0.0, 1.0);

        gradientColors.add(
          Color.fromARGB((opacityToUse * 255).round(), (r * 255).round(), (g * 255).round(), (b * 255).round()),
        );
      }
    }

    // Add the first color at the end for seamless loop
    colorStops.add(1.0);
    gradientColors.add(colors[0].withValues(alpha: opacityToUse));

    // Create a sweep gradient that rotates
    // Flutter's sweep gradient starts at 0 radians (3 o'clock, right side)
    // To start at the top (12 o'clock), we need to offset by -π/2
    const startAngle = -math.pi / 2;
    final endAngle = startAngle + 2 * math.pi;

    final matrix = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..rotateZ(rotation)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);

    return ui.Gradient.sweep(
      center,
      gradientColors,
      colorStops,
      TileMode.repeated,
      startAngle,
      endAngle,
      matrix.storage,
    );
  }
}
