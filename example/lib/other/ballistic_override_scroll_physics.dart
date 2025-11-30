import 'package:flutter/widgets.dart';

class BallisticOverrideScrollPhysics extends ScrollPhysics {
  const BallisticOverrideScrollPhysics({super.parent, required this.onCreateBallisticSimulation});

  final Simulation? Function(ScrollMetrics position, double velocity) onCreateBallisticSimulation;

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) =>
      onCreateBallisticSimulation(position, velocity);

  @override
  BallisticOverrideScrollPhysics applyTo(ScrollPhysics? ancestor) => BallisticOverrideScrollPhysics(
    onCreateBallisticSimulation: onCreateBallisticSimulation,
    parent: buildParent(ancestor),
  );
}
