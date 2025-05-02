import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.path, {
    super.key,
    this.color,
    this.width,
    this.height,
    this.size,
  }) : assert(
         size == null && width == null && height == null ||
             size != null && width == null && height == null ||
             size == null && width != null && height != null,
         'Specify either size or width and height',
       );

  final String path;
  final Color? color;
  final double? width;
  final double? height;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? this.color;
    return SvgPicture.asset(
      path,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      width: size ?? width,
      height: size ?? height,
    );
  }
}
