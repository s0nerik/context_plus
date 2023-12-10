import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signals/signals.dart' as sgnls;

import 'observable_listener_types.dart';

sealed class Publisher {
  Publisher._({
    required this.observableCount,
    required this.initialDelay,
    required this.interval,
  });

  factory Publisher({
    required ObservableType observableType,
    required int observableCount,
    required Duration initialDelay,
    required Duration interval,
  }) {
    switch (observableType) {
      case ObservableType.future:
      case ObservableType.synchronousFuture:
        throw UnimplementedError();
      case ObservableType.stream:
        return StreamPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
      case ObservableType.valueStream:
        return ValueStreamPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
      case ObservableType.listenable:
      case ObservableType.valueListenable:
        return ValueNotifierPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
      case ObservableType.signal:
        return SignalPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
    }
  }

  final int observableCount;
  final Duration initialDelay;
  final Duration interval;

  bool _isDisposed = false;

  @protected
  void publish(int index);

  @nonVirtual
  Future<void> publishWhileMounted(BuildContext context) async {
    var index = 0;
    if (initialDelay > Duration.zero) {
      await Future.delayed(initialDelay);
    }
    while (context.mounted && !_isDisposed) {
      publish(index);
      index++;
      await Future.delayed(interval);
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
  StreamPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final streams = <Stream<int>>[];
    for (var i = 0; i < observableCount; i++) {
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
  ValueStreamPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final streams = <Stream<int>>[];
    for (var i = 0; i < observableCount; i++) {
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
  ValueNotifierPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final valueListenables = <ValueListenable<int>>[];
    for (var i = 0; i < observableCount; i++) {
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
  SignalPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final signals = <sgnls.Signal<int>>[];
    for (var i = 0; i < observableCount; i++) {
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
