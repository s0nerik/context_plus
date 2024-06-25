import 'package:flutter/material.dart';

class TypewriterText extends StatelessWidget {
  const TypewriterText({
    super.key,
    required this.rows,
    required this.intervals,
    required this.progress,
    this.style,
  });

  final List<(double start, double end)> intervals;
  final List<String> rows;
  final double progress;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final visibleRows = <String>[];
    for (int i = 0; i < intervals.length; i++) {
      final (start, end) = intervals[i];
      if (progress < start) {
        break;
      }

      final row = rows[i];
      if (progress < end) {
        final interval = end - start;
        final visibleCharacters = (progress - start) / interval * row.length;
        final substring = row.substring(0, visibleCharacters.toInt());

        visibleRows.add(substring);
      } else {
        visibleRows.add(row);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in visibleRows) Text(row, style: style),
      ],
    );
  }
}
