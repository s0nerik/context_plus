import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// A [Tween] with a `const` constructor.
///
/// Unlike [Tween], this class has immutable [begin] and [end] values,
/// allowing it to be used in const contexts.
///
/// ```dart
/// const tween = ConstTween<double>(begin: 0.0, end: 100.0);
/// ```
class ConstTween<T extends Object?> extends Animatable<T> {
  /// Creates a const tween with the given [begin] and [end] values.
  const ConstTween({required this.begin, required this.end});

  /// The value this variable has at the beginning of the animation.
  final T begin;

  /// The value this variable has at the end of the animation.
  final T end;

  /// Returns the value this variable has at the given animation clock value.
  ///
  /// The default implementation uses the `+`, `-`, and `*` operators on `T`.
  @protected
  T lerp(double t) {
    // ignore: avoid_dynamic_calls
    return (begin as dynamic) + ((end as dynamic) - (begin as dynamic)) * t as T;
  }

  /// Returns the interpolated value for the current value of the given animation.
  ///
  /// This method returns [begin] and [end] when the animation values are 0.0 or
  /// 1.0, respectively.
  @override
  T transform(double t) {
    if (t == 0.0) {
      return begin;
    }
    if (t == 1.0) {
      return end;
    }
    return lerp(t);
  }

  @override
  String toString() => '${objectRuntimeType(this, 'ConstTween')}($begin \u2192 $end)';
}

class ConstCurveTween extends Animatable<double> {
  /// Creates a curve tween.
  const ConstCurveTween({required this.curve});

  /// The curve to use when transforming the value of the animation.
  final Curve curve;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      assert(curve.transform(t).round() == t);
      return t;
    }
    return curve.transform(t);
  }

  @override
  String toString() => '${objectRuntimeType(this, 'ConstCurveTween')}(curve: $curve)';
}
