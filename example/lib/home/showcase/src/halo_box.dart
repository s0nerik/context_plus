import 'package:color_mesh/color_mesh.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HaloBox extends StatelessWidget {
  const HaloBox({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  static final _key = Ref<GlobalKey>();
  static final _show = Ref<ValueNotifier<bool>>();

  @override
  Widget build(BuildContext context) {
    final key = _key.bind(context, () => GlobalKey());
    final show = _show.bind(context, () => ValueNotifier(true));

    return VisibilityDetector(
      key: key,
      onVisibilityChanged: (info) {
        show.value = info.visibleFraction > 0;
      },
      child: SizedOverflowBox(
        size: Size(width, height),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          alignment: Alignment.center,
          sizeCurve: const Interval(0.0, 0.0),
          crossFadeState: show.watch(context)
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: ShaderMask(
            shaderCallback: (rect) => RadialGradient(
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.0),
              ],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
            blendMode: BlendMode.modulate,
            child: UnconstrainedBox(
              clipBehavior: Clip.none,
              child: SizedBox(
                width: width * 2,
                height: height * 2,
                child: Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: AnimatedMeshGradientContainer(
                    duration: const Duration(milliseconds: 500),
                    gradient: MeshGradient(
                      colors: [
                        Colors.yellow,
                        Colors.green,
                        Colors.blue,
                        Colors.purple[300]!,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
