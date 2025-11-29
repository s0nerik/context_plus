import 'package:context_plus/context_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class ScrollHijackZone extends StatelessWidget {
  const ScrollHijackZone({
    super.key,
    required this.scrollController,
    required this.builder,
    this.hijackThreshold = 0.5,
    this.hijackStartOffset = 0,
    this.hijackEndOffset = double.infinity,
    this.onHijackedScroll,
    this.onHijackedScrollEnd,
  });

  final ScrollController scrollController;
  final Widget Function(BuildContext context, ScrollController scrollCtrl, ScrollPhysics? physics) builder;
  final double hijackThreshold;
  final double hijackStartOffset;
  final double hijackEndOffset;
  final void Function(double offset)? onHijackedScroll;
  final void Function()? onHijackedScrollEnd;

  @override
  Widget build(BuildContext context) {
    final hijackScrollEvents = scrollController.watchOnly(
      context,
      (ctrl) => ctrl.hasClients && ctrl.offset > hijackStartOffset && ctrl.offset < hijackEndOffset,
    );
    final lastScrollDy = context.use(() => ValueNotifier<double?>(null), key: 'lastScrollDy');
    final lastScrollEndDy = context.use(() => ValueNotifier<double?>(null), key: 'lastScrollEndDy');
    return Listener(
      onPointerSignal: (ps) {
        if (ps is! PointerScrollEvent) return;
        debugPrint('dy: ${ps.scrollDelta.dy}');

        if (!hijackScrollEvents) return;
        if (!scrollController.hasClients) return;
        debugPrint('onPointerSignal');

        final pos = scrollController.position;
        final offset = pos.pixels;
        final dy = ps.scrollDelta.dy;
        final newOffset = (offset + dy).clamp(hijackStartOffset, hijackEndOffset);

        if (newOffset < hijackStartOffset || newOffset > hijackEndOffset) {
          debugPrint('newOffset < hijackStartOffset || newOffset > hijackEndOffset');
          pos.jumpTo(newOffset);
          lastScrollDy.value = null;
          lastScrollEndDy.value = null;
          onHijackedScrollEnd?.call();
          return;
        }

        if (dy.abs() > hijackThreshold) {
          debugPrint('dy.abs() > hijackThreshold');
          pos.jumpTo(newOffset);
          lastScrollDy.value = dy;
          lastScrollEndDy.value = null;
          onHijackedScroll?.call(newOffset);
          return;
        }

        final prevScrollEndDy = lastScrollEndDy.value;
        if (prevScrollEndDy == null) {
          debugPrint('prevScrollEndDy == null');
          pos.jumpTo(newOffset);
          lastScrollDy.value = dy;
          lastScrollEndDy.value = dy;
          onHijackedScrollEnd?.call();
          return;
        }

        if (dy.abs() > prevScrollEndDy.abs()) {
          debugPrint('dy.abs() > prevScrollEndDy.abs()');
          pos.jumpTo(newOffset);
          lastScrollDy.value = dy;
          lastScrollEndDy.value = null;
          onHijackedScroll?.call(newOffset);
          return;
        }
      },
      child: builder(context, scrollController, hijackScrollEvents ? const NeverScrollableScrollPhysics() : null),
    );
  }
}
