import 'package:flutter/material.dart';

class DebugAnimSlider extends StatefulWidget {
  const DebugAnimSlider({super.key, required this.controller});

  final AnimationController controller;

  @override
  State<DebugAnimSlider> createState() => _DebugAnimSliderState();
}

class _DebugAnimSliderState extends State<DebugAnimSlider> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.controller.value;
    widget.controller.addListener(_onControllerValueChanged);
  }

  @override
  void didUpdateWidget(DebugAnimSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerValueChanged);
      widget.controller.addListener(_onControllerValueChanged);
      _sliderValue = widget.controller.value;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  void _onControllerValueChanged() {
    if (mounted && _sliderValue != widget.controller.value) {
      setState(() {
        _sliderValue = widget.controller.value;
      });
    }
  }

  void _onSliderValueChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
    widget.controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Slider(
      value: _sliderValue.clamp(controller.lowerBound, controller.upperBound),
      min: controller.lowerBound,
      max: controller.upperBound,
      onChanged: _onSliderValueChanged,
    );
  }
}
