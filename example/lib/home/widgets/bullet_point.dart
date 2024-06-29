import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({
    super.key,
    required this.bulletTopMargin,
    required this.child,
  });

  final double bulletTopMargin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: EdgeInsets.only(
            top: bulletTopMargin,
            left: 4,
            right: 6,
          ),
          decoration: BoxDecoration(
            color: textStyle.color ?? Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        child,
      ],
    );
  }
}
