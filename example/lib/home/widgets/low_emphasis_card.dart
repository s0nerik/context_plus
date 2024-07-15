import 'package:flutter/material.dart';

class LowEmphasisCard extends StatelessWidget {
  const LowEmphasisCard({
    super.key,
    this.margin,
    required this.child,
  });

  final EdgeInsetsGeometry? margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: const Color(0xFF111111),
      child: child,
    );
  }
}
