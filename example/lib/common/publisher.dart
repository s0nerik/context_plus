import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:rxdart/rxdart.dart';
import 'package:signals/signals.dart' as sgnls;
import 'package:state_beacon/state_beacon.dart' as bcn;
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;

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
      case ObservableType.mobxObservable:
        return MobxObservablePublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
      case ObservableType.beacon:
        return BeaconPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
        );
      case ObservableType.cubit:
        return CubitPublisher(
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

final class BeaconPublisher extends Publisher {
  BeaconPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final beacons = <bcn.WritableBeacon<int>>[];
    for (var i = 0; i < observableCount; i++) {
      final beacon = bcn.Beacon.writable(0);
      _beacons.add(beacon);
      beacons.add(beacon);
    }
    this.beacons = UnmodifiableListView(beacons);
  }

  final _beacons = <bcn.WritableBeacon<int>>[];
  late final List<bcn.ReadableBeacon<int>> beacons;

  @override
  void publish(int index) {
    for (final beacon in _beacons) {
      beacon.value = index;
    }
  }

  @override
  void _dispose() {}
}

final class MobxObservablePublisher extends Publisher {
  MobxObservablePublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final observables = <mobx.Observable<int>>[];
    for (var i = 0; i < observableCount; i++) {
      final observable = mobx.Observable(0);
      _observables.add(observable);
      observables.add(observable);
    }
    this.observables = UnmodifiableListView(observables);
  }

  final _observables = <mobx.Observable<int>>[];
  late final List<mobx.Observable<int>> observables;

  @override
  void publish(int index) {
    for (final observable in _observables) {
      mobx.runInAction(() {
        observable.value = index;
      });
    }
  }

  @override
  void _dispose() {}
}

class _IntCubit extends bloc.Cubit<int> {
  _IntCubit(super.initialState);

  void set(int i) => emit(i);
}

final class CubitPublisher extends Publisher {
  CubitPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
  }) : super._() {
    final cubits = <_IntCubit>[];
    for (var i = 0; i < observableCount; i++) {
      final observable = _IntCubit(0);
      _cubits.add(observable);
      cubits.add(observable);
    }
    this.cubits = UnmodifiableListView(cubits);
  }

  final _cubits = <_IntCubit>[];
  late final List<bloc.Cubit<int>> cubits;

  @override
  void publish(int index) {
    for (final cubit in _cubits) {
      cubit.set(index);
    }
  }

  @override
  void _dispose() {
    for (final cubit in _cubits) {
      cubit.close();
    }
  }
}
