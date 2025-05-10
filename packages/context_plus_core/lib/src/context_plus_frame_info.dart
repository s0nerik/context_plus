import 'package:flutter/scheduler.dart';

abstract final class ContextPlusFrameInfo {
  static void ensureFrameTracking() {
    if (_isInitialized) return;
    _isInitialized = true;
    _onEndFrameCallback(null);
  }

  static final _postFrameCallbacks = <void Function()>[];
  static void registerPostFrameCallback(void Function() callback) {
    _postFrameCallbacks.add(callback);
  }

  static void unregisterPostFrameCallback(void Function() callback) {
    _postFrameCallbacks.remove(callback);
  }

  // Cache the tear-off to avoid creating a new lambda for each `addPostFrameCallback`.
  static const _onEndFrameCallback = _onEndFrame;
  static void _onEndFrame(_) {
    for (int i = 0; i < _postFrameCallbacks.length; i++) {
      _postFrameCallbacks[i]();
    }

    _currentFrameId += 1;
    SchedulerBinding.instance.addPostFrameCallback(_onEndFrameCallback);
  }

  static bool _isInitialized = false;
  static int _currentFrameId = -1;

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  static int get currentFrameId => _currentFrameId;

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  static bool get isBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        _currentFrameId == -1 && phase == SchedulerPhase.idle;
  }
}
