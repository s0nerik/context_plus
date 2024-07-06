import 'package:color_mesh/color_mesh.dart';
import 'package:flutter/material.dart';

class HaloBox extends StatelessWidget {
  const HaloBox({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: Size(width, height),
      child: ShaderMask(
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
    );
  }
}
