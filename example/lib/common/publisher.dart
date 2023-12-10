import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signals/signals.dart' as sgnls;

import 'observable_listener_types.dart';

sealed class Publisher {
  Publisher._();

  factory Publisher({
    required ObservableType observableType,
    required int observableCount,
  }) {
    switch (observableType) {
      case FutureObservableType.future:
      case FutureObservableType.synchronousFuture:
        throw UnimplementedError();
      case StreamObservableType.stream:
        return StreamPublisher(streamCount: observableCount);
      case StreamObservableType.valueStream:
        return ValueStreamPublisher(streamCount: observableCount);
      case ListenableObservableType.listenable:
      case ListenableObservableType.valueListenable:
        return ValueNotifierPublisher(notifierCount: observableCount);
      case OtherObservableType.signal:
        return SignalPublisher(signalCount: observableCount);
    }
  }

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
    _dispose();
  }

  @protected
  void _dispose();
}

final class StreamPublisher extends Publisher {
  StreamPublisher({required int streamCount}) : super._() {
    final streams = <Stream<int>>[];
    for (var i = 0; i < streamCount; i++) {
      final streamController = StreamController<int>.broadcast();
      _streamControllers.add(streamController);
      streams.add(streamController.stream);
    }
    this.streams = UnmodifiableListView(streams);
  }

  final _streamControllers = <StreamController<int>>[];
  late final List<Stream<int>> streams;

  @override
  void publish(int index) {
    for (final controller in _streamControllers) {
      controller.add(index);
    }
  }

  @override
  void _dispose() {
    for (final controller in _streamControllers) {
      controller.close();
    }
  }
}

final class ValueStreamPublisher extends Publisher {
  ValueStreamPublisher({required int streamCount}) : super._() {
    final streams = <Stream<int>>[];
    for (var i = 0; i < streamCount; i++) {
      final subject = BehaviorSubject.seeded(0);
      _subjects.add(subject);
      streams.add(subject.stream);
    }
    this.streams = UnmodifiableListView(streams);
  }

  final _subjects = <BehaviorSubject<int>>[];
  late final List<Stream<int>> streams;

  @override
  void publish(int index) {
    for (final subject in _subjects) {
      subject.add(index);
    }
  }

  @override
  void _dispose() {
    for (final subject in _subjects) {
      subject.close();
    }
  }
}

final class ValueNotifierPublisher extends Publisher {
  ValueNotifierPublisher({required int notifierCount}) : super._() {
    final valueListenables = <ValueListenable<int>>[];
    for (var i = 0; i < notifierCount; i++) {
      final valueNotifier = ValueNotifier<int>(0);
      _valueNotifiers.add(valueNotifier);
      valueListenables.add(valueNotifier);
    }
    this.valueListenables = UnmodifiableListView(valueListenables);
  }

  final _valueNotifiers = <ValueNotifier<int>>[];
  late final List<ValueListenable<int>> valueListenables;

  @override
  void publish(int index) {
    for (final notifier in _valueNotifiers) {
      notifier.value = index;
    }
  }

  @override
  void _dispose() {
    for (final notifier in _valueNotifiers) {
      notifier.dispose();
    }
  }
}

final class SignalPublisher extends Publisher {
  SignalPublisher({required int signalCount}) : super._() {
    final signals = <sgnls.Signal<int>>[];
    for (var i = 0; i < signalCount; i++) {
      final signal = sgnls.signal(0);
      _signals.add(signal);
      signals.add(signal);
    }
    this.signals = UnmodifiableListView(signals);
  }

  final _signals = <sgnls.Signal<int>>[];
  late final List<sgnls.ReadonlySignal<int>> signals;

  @override
  void publish(int index) {
    for (final signal in _signals) {
      signal.value = index;
    }
  }

  @override
  void _dispose() {}
}