import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';

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
    final anim = CurvedAnimation(parent: animCtrl, curve: curve);
    return ClipRect(
      child: AnimatedSize(
        duration: duration,
        curve: curve,
        alignment: Alignment.centerLeft,
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              key: const Key('prev'),
              left: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0),
                  end: const Offset(0, -1),
                ).animate(anim),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1, end: 0).animate(anim),
                  child: prevChild,
                ),
              ),
            ),
            Positioned(
              key: const Key('current'),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(anim),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(anim),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
