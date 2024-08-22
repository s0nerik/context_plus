import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';

enum ShowcaseKeyframe {
  // Flutter
  vanillaFlutter(frame: 0, lastFrame: 55, windowHeight: 952),
  // Bye, InheritedWidget! Hello, Ref!
  ref(frame: 56, lastFrame: 111, windowHeight: 742),
  // Bye, StatefulWidget! Hello, .bind()!
  bind(frame: 112, lastFrame: 154, windowHeight: 572),
  // Bye, Builders! Hello, .watch()!
  // (context_plus migration is complete)
  watch(frame: 155, lastFrame: 155, windowHeight: 494),
  ;

  final int frame;
  final int lastFrame;
  final double windowHeight;
  final double heightFraction;

  const ShowcaseKeyframe({
    required this.frame,
    required this.lastFrame,
    required this.windowHeight,
  }) : heightFraction = windowHeight / _initialWindowHeight;

  static const _initialWindowHeight = 952.0;

  bool get isInitial => this == vanillaFlutter;
  bool get isFinal => this == watch;

  ShowcaseKeyframe? get next {
    final nextIndex = index + 1;
    if (nextIndex >= values.length) return null;
    return values[nextIndex];
  }

  ShowcaseKeyframe? get previous {
    final previousIndex = index - 1;
    if (previousIndex < 0) return null;
    return values[previousIndex];
  }
}

class ShowcaseRiveController extends SimpleAnimation with ChangeNotifier {
  ShowcaseRiveController() : super('Timeline 1', autoplay: false);

  static const windowWidth = 520.0;
  static const initialWindowHeight = 952.0;
  static const artboardWidth = 536.0;
  static const artboardHeight = 968.0;
  static const totalFrames = 155;

  var _targetKeyframe = ShowcaseKeyframe.vanillaFlutter;
  double get _direction => instance?.direction ?? 1;
  double get frame {
    if (instance == null) return 0;
    return instance!.time * instance!.animation.fps;
  }

  ShowcaseKeyframe get currentKeyframe {
    final f = frame.round();
    if (_direction >= 0) {
      return ShowcaseKeyframe.values.lastWhere(
        (k) => f >= k.frame,
        orElse: () => ShowcaseKeyframe.values.last,
      );
    } else {
      return ShowcaseKeyframe.values.firstWhere(
        (k) => k.frame >= f,
        orElse: () => ShowcaseKeyframe.values.first,
      );
    }
  }

  ShowcaseKeyframe? get nextKeyframe {
    if (_direction >= 0) {
      return currentKeyframe.next;
    } else {
      return currentKeyframe.previous;
    }
  }

  double get estimatedWindowHeight => _calculateWindowHeight(frame);
  double get animationProgress => (frame / totalFrames).clamp(0.0, 1.0);

  @override
  bool init(RuntimeArtboard artboard) {
    if (instance != null) {
      animateToKeyframe(currentKeyframe);
      return true;
    }
    final result = super.init(artboard);
    apply(artboard, 0);
    return result;
  }

  void animateToKeyframe(
    ShowcaseKeyframe keyframe, {
    bool jump = false,
  }) {
    isActive = false;

    instance!.animation.speed = jump ? 10000 : 0.5;
    instance!.direction = keyframe.frame >= frame ? 1 : -1;
    _targetKeyframe = keyframe;
    isActive = true;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    final oldFrame = frame;
    super.apply(artboard, elapsedSeconds);

    final direction = instance!.direction;
    if (direction > 0 && frame >= _targetKeyframe.frame ||
        direction < 0 && frame <= _targetKeyframe.frame) {
      isActive = false;
      super.apply(artboard, 0);
    }

    if (oldFrame != frame) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }
}

/// Rive for Flutter doesn't support artboard size animation, so let's do it
/// manually.
double _calculateWindowHeight(num frame) {
  const epsilon = 0.0001;

  final transition = _windowHeightTransitions
      .where(
        (t) => t.startFrame - epsilon <= frame && frame <= t.endFrame + epsilon,
      )
      .first;

  final rawProgress = (frame - transition.startFrame) /
      (transition.endFrame - transition.startFrame);
  final progress =
      const ElasticOutCurve(1).transform(rawProgress.clamp(0.0, 1.0));
  final result = transition.startHeight +
      (transition.endHeight - transition.startHeight) * progress;
  return result;
}

const _windowHeightTransitions = [
  _WindowHeightTransition(0, 20, 952, 952),
  _WindowHeightTransition(20, 35, 952, 742),
  _WindowHeightTransition(35, 66, 742, 742),
  _WindowHeightTransition(66, 91, 742, 571.14),
  _WindowHeightTransition(91, 122, 571.14, 571.14),
  _WindowHeightTransition(122, 137, 571.14, 493.34),
  _WindowHeightTransition(137, 155, 493.34, 493.34),
];

class _WindowHeightTransition {
  const _WindowHeightTransition(
    this.startFrame,
    this.endFrame,
    this.startHeight,
    this.endHeight,
  );

  final int startFrame;
  final int endFrame;
  final double startHeight;
  final double endHeight;
}
