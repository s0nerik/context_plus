import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';

enum ShowcaseKeyframe {
  // Flutter
  vanillaFlutter(frame: 0, heightFraction: 1),
  // Bye, InheritedWidget! Hello, Ref!
  ref(frame: 56, heightFraction: 0.783058),
  // Bye, StatefulWidget! Hello, .bind()!
  bind(frame: 112, heightFraction: 0.60655),
  // Bye, Builders! Hello, .watch()!
  // (context_plus migration is complete)
  watch(frame: 157, heightFraction: 0.527211),
  ;

  final int frame;
  final double heightFraction;

  const ShowcaseKeyframe({
    required this.frame,
    required this.heightFraction,
  });

  bool get isInitial => this == vanillaFlutter;
  bool get isFinal => this == watch;
}

class ShowcaseRiveController extends SimpleAnimation {
  ShowcaseRiveController() : super('Timeline 1', autoplay: false);

  final _currentFrame = ValueNotifier(0);
  ValueListenable<int> get currentFrame => _currentFrame;

  final _targetKeyframe = ValueNotifier(ShowcaseKeyframe.values.first);
  ValueListenable<ShowcaseKeyframe> get targetKeyframe => _targetKeyframe;

  final _currentKeyframe = ValueNotifier(ShowcaseKeyframe.values.first);
  ValueListenable<ShowcaseKeyframe> get currentKeyframe => _currentKeyframe;

  final _nextKeyframe = ValueNotifier(ShowcaseKeyframe.values.first);
  ValueListenable<ShowcaseKeyframe> get nextKeyframe => _nextKeyframe;

  final _keyframeTransitionProgress = ValueNotifier(1.0);
  ValueListenable<double> get keyframeTransitionProgress =>
      _keyframeTransitionProgress;

  static const _artboardWidth = 536.0;
  static const _artboardHeight = 968.0;
  static const _artboardAspectRatio = _artboardWidth / _artboardHeight;

  final _optimalWidth = ValueNotifier(_artboardWidth);
  ValueListenable<double> get optimalWidth => _optimalWidth;

  final optimalHeight = _artboardHeight;

  double _calculateCurrentFrame() => instance!.time * instance!.animation.fps;

  double _calculateOptimalWidth({
    required double frame,
  }) {
    const curve = ElasticInOutCurve(1);

    final nextKeyframe = ShowcaseKeyframe.values.firstWhere(
      (k) => k.frame > frame,
      orElse: () => ShowcaseKeyframe.values.last,
    );
    final prevKeyframe = ShowcaseKeyframe.values[nextKeyframe.index - 1];

    final progress = (frame - prevKeyframe.frame) /
        (nextKeyframe.frame - prevKeyframe.frame);

    final transformedProgress = curve.transform(progress);

    final heightFraction = prevKeyframe.heightFraction +
        (nextKeyframe.heightFraction - prevKeyframe.heightFraction) *
            transformedProgress;
    final widthFraction = 1 + (1 - heightFraction) * _artboardAspectRatio;

    return widthFraction * _artboardWidth;
  }

  @override
  bool init(RuntimeArtboard artboard) {
    final result = super.init(artboard);

    final currentFrame = _calculateCurrentFrame();
    _currentFrame.value = currentFrame.ceil();
    _targetKeyframe.value = ShowcaseKeyframe.values.firstWhere(
      (keyframe) => keyframe.frame >= currentFrame,
      orElse: () => ShowcaseKeyframe.values.last,
    );
    _currentKeyframe.value = ShowcaseKeyframe.values.lastWhere(
      (keyframe) => keyframe.frame <= currentFrame,
      orElse: () => ShowcaseKeyframe.values.last,
    );
    _keyframeTransitionProgress.value = 1.0;
    _optimalWidth.value = _calculateOptimalWidth(frame: currentFrame);

    apply(artboard, 0);
    return result;
  }

  void animateToKeyframe(
    ShowcaseKeyframe keyframe, {
    bool jump = false,
  }) {
    isActive = false;

    instance!.animation.speed = jump ? 10000 : 0.5;
    instance!.direction = keyframe.frame > _calculateCurrentFrame() ? 1 : -1;
    _targetKeyframe.value = keyframe;
    isActive = true;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    super.apply(artboard, elapsedSeconds);

    final direction = instance!.direction;
    final currentFrame = _calculateCurrentFrame();

    _currentFrame.value = currentFrame.ceil();
    _optimalWidth.value = _calculateOptimalWidth(frame: currentFrame);
    _currentKeyframe.value = direction > 0
        ? ShowcaseKeyframe.values.lastWhere(
            (keyframe) => keyframe.frame <= currentFrame,
            orElse: () => ShowcaseKeyframe.values.last,
          )
        : ShowcaseKeyframe.values.firstWhere(
            (keyframe) => keyframe.frame >= currentFrame,
            orElse: () => ShowcaseKeyframe.values.first,
          );
    _nextKeyframe.value = direction > 0
        ? ShowcaseKeyframe.values.firstWhere(
            (k) => k.frame > currentFrame,
            orElse: () => ShowcaseKeyframe.values.last,
          )
        : ShowcaseKeyframe.values.lastWhere(
            (k) => k.frame < currentFrame,
            orElse: () => ShowcaseKeyframe.values.first,
          );

    if (_nextKeyframe.value != _currentKeyframe.value) {
      _keyframeTransitionProgress.value =
          (currentFrame - _currentKeyframe.value.frame).abs() /
              (_nextKeyframe.value.frame - _currentKeyframe.value.frame).abs();
    } else {
      _keyframeTransitionProgress.value = 1.0;
    }

    if (direction > 0 && currentFrame >= _targetKeyframe.value.frame ||
        direction < 0 && currentFrame <= _targetKeyframe.value.frame) {
      isActive = false;
      super.apply(artboard, 0);
    }
  }

  @override
  void reset() {
    super.reset();
    _currentFrame.value = 0;
    _targetKeyframe.value = ShowcaseKeyframe.values.first;
  }
}
