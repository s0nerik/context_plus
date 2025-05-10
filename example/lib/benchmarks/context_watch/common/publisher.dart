import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:get/get.dart' as getx;
import 'package:mobx/mobx.dart' as mobx;
import 'package:rxdart/rxdart.dart';
import 'package:signals_flutter/signals_flutter.dart' as sgnls;

import 'observable_listener_types.dart';

sealed class Publisher {
  Publisher._({
    required this.observableCount,
    required this.initialDelay,
    required this.interval,
    required this.jitterMin,
    required this.jitterMax,
  });

  factory Publisher({
    required ObservableType observableType,
    required int observableCount,
    required Duration initialDelay,
    required Duration interval,
    required Duration jitterMin,
    required Duration jitterMax,
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
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.valueStream:
        return ValueStreamPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.valueListenable:
        return ValueNotifierPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.signal:
        return SignalPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.mobxObservable:
        return MobxObservablePublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.cubit:
        return CubitPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
      case ObservableType.getRx:
        return GetxPublisher(
          observableCount: observableCount,
          initialDelay: initialDelay,
          interval: interval,
          jitterMin: jitterMin,
          jitterMax: jitterMax,
        );
    }
  }

  final int observableCount;
  final Duration initialDelay;
  final Duration interval;
  final Duration jitterMin;
  final Duration jitterMax;

  final _random = Random(DateTime.now().microsecondsSinceEpoch);

  @protected
  Duration get jitter =>
      jitterMin + (jitterMax - jitterMin) * _random.nextDouble();

  bool _isDisposed = false;

  @protected
  Future<void> publish(int index);

  @nonVirtual
  Future<void> publishWhileMounted(BuildContext context) async {
    var index = 0;
    if (initialDelay > Duration.zero) {
      await Future.delayed(initialDelay);
    }
    while (context.mounted && !_isDisposed) {
      await publish(index);
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final controller in _streamControllers) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final subject in _subjects) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final notifier in _valueNotifiers) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final signal in _signals) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
      signal.value = index;
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final observable in _observables) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
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
    required super.jitterMin,
    required super.jitterMax,
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
  Future<void> publish(int index) async {
    for (final cubit in _cubits) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
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

final class GetxPublisher extends Publisher {
  GetxPublisher({
    required super.observableCount,
    required super.initialDelay,
    required super.interval,
    required super.jitterMin,
    required super.jitterMax,
  }) : super._() {
    final observables = <getx.Rx<int>>[];
    for (var i = 0; i < observableCount; i++) {
      final rxObservable = getx.Rx<int>(0);
      _observables.add(rxObservable);
      observables.add(rxObservable);
    }
    this.observables = UnmodifiableListView(observables);
  }

  final _observables = <getx.Rx<int>>[];
  late final List<getx.Rx<int>> observables;

  @override
  Future<void> publish(int index) async {
    for (final rxObservable in _observables) {
      await Future.delayed(jitter);
      if (_isDisposed) break;
      rxObservable.value = index;
    }
  }

  @override
  void _dispose() {
    for (final rxObservable in _observables) {
      rxObservable.close();
    }
  }
}
