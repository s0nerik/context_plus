import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signals/signals.dart' as signals;

sealed class ObservablePublisher {
  bool _isDisposed = false;

  @protected
  void publish(int index);

  @nonVirtual
  Future<void> publishWhileMounted(BuildContext context) async {
    var index = 0;
    while (context.mounted && !_isDisposed) {
      await Future.delayed(const Duration(milliseconds: 1));
      if (!context.mounted || _isDisposed) {
        break;
      }
      publish(index);
      index++;
    }
  }

  @nonVirtual
  void dispose() {
    _isDisposed = true;
  }
}

final class StreamPublisher extends ObservablePublisher {
  StreamPublisher();

  final _streamController = StreamController<int>.broadcast();
  late final Stream<int> stream = _streamController.stream;

  @override
  void publish(int index) => _streamController.add(index);
}

final class ValueStreamPublisher extends ObservablePublisher {
  ValueStreamPublisher();

  final _subject = BehaviorSubject.seeded(0);
  late final ValueStream<int> stream = _subject.stream;

  @override
  void publish(int index) => _subject.value = index;
}

final class ValueNotifierPublisher extends ObservablePublisher {
  ValueNotifierPublisher();

  final _valueNotifier = ValueNotifier<int>(0);
  late final ValueListenable<int> valueListenable = _valueNotifier;

  @override
  void publish(int index) => _valueNotifier.value = index;
}

final class SignalPublisher extends ObservablePublisher {
  SignalPublisher();

  final _signal = signals.signal(0);
  late final signals.Signal<int> signal = _signal;

  @override
  void publish(int index) => _signal.value = index;
}
