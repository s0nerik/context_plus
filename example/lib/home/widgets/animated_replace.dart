import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';

import 'replace_transition.dart';

class AnimatedReplace extends StatelessWidget {
  const AnimatedReplace({
    super.key,
    required this.prevChild,
    required this.child,
    required this.duration,
    this.curve = Curves.easeInOut,
  });

  final Widget prevChild;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final animCtrl = context.use(
      () =>
          AnimationController(vsync: context.vsync, duration: duration)
            ..forward(),
      key: (prevChild.key, child.key, duration),
    );
    final anim = context.use(
      () => CurvedAnimation(parent: animCtrl, curve: curve),
      key: (animCtrl, curve),
    );

    return ClipRect(
      child: AnimatedSize(
        duration: duration,
        curve: curve,
        alignment: Alignment.centerLeft,
        child: ReplaceTransition(
          animation: anim,
          prevChild: prevChild,
          child: child,
        ),
      ),
    );
  }
}
