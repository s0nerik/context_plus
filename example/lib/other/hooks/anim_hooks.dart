import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';

extension AnimHooks on BuildContext {
  Animation<double> useIntervalAnimation(
    Animation<double> parent,
    (double begin, double end) interval, {
    Curve? curve,
    Object? key,
  }) => use(
    key: ('useIntervalAnimation', parent, interval, curve, key),
    () => CurvedAnimation(
      parent: parent,
      curve: Interval(interval.$1, interval.$2, curve: curve ?? Curves.linear),
    ),
  );

  Animation<double> useDoubleTweenAnimation(
    Animation<double> parent, {
    required (double begin, double end) tween,
    (double begin, double end)? interval,
    Curve? curve,
    Object? key,
  }) {
    Animation<double>? curvedAnim;
    if (interval != null) {
      curvedAnim = useIntervalAnimation(
        parent,
        interval,
        curve: curve,
        key: key,
      );
    }
    final anim = curvedAnim ?? parent;
    return use(
      key: ('useDoubleTweenAnimation', anim, tween, interval, curve, key),
      () => Tween(begin: tween.$1, end: tween.$2).animate(anim),
    );
  }

  Animation<Offset> useOffsetTweenAnimation(
    Animation<double> parent, {
    required ((double dx, double dy) begin, (double dx, double dy) end) tween,
    (double begin, double end)? interval,
    Curve? curve,
    Object? key,
  }) {
    Animation<double>? curvedAnim;
    if (interval != null) {
      curvedAnim = useIntervalAnimation(
        parent,
        interval,
        curve: curve,
        key: key,
      );
    }
    final anim = curvedAnim ?? parent;
    return use(
      key: ('useOffsetTweenAnimation', anim, tween, interval, curve, key),
      () => Tween(
        begin: Offset(tween.$1.$1, tween.$1.$2),
        end: Offset(tween.$2.$1, tween.$2.$2),
      ).animate(anim),
    );
  }
}
