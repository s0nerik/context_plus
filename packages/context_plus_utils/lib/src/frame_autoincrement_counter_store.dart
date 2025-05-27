import 'dart:collection';

import 'package:context_plus_core/context_plus_core.dart';

/// A store that maintains auto-incrementing counters for different types within a frame.
/// The counters are reset when the frame changes.
class FrameAutoincrementCounterStore {
  FrameAutoincrementCounterStore() {
    _frameId = ContextPlusFrameInfo.currentFrameId;
  }

  late int _frameId;

  final _counters = HashMap<Object?, int>();

  /// Gets the next counter value for the given type.
  /// The counter is reset when the frame changes.
  int getCounter({Object? type}) {
    if (ContextPlusFrameInfo.currentFrameId != _frameId) {
      _frameId = ContextPlusFrameInfo.currentFrameId;
      _counters.clear();
    }

    final counter = _counters[type] ?? 0;
    _counters[type] = counter + 1;
    return counter;
  }

  void dispose() {}
}
