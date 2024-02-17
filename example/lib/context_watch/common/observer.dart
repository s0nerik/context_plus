// ignore_for_file: unused_element

import 'package:context_plus/context_plus.dart';
import 'package:context_watch_beacon/context_watch_beacon.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:example/context_watch/common/publisher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_mobx/flutter_mobx.dart' as mobx;
import 'package:get/get.dart' as getx;
import 'package:mobx/mobx.dart' as mobx;
import 'package:signals_flutter/signals_flutter.dart' as sgnls;
import 'package:state_beacon/state_beacon.dart' as bcn;

import 'observable_listener_types.dart';

class Observer extends StatelessWidget {
  const Observer({
    super.key,
    required this.publisher,
    required this.listenerType,
    required this.visualize,
  });

  final Publisher publisher;
  final ListenerType listenerType;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return switch (publisher) {
      StreamPublisher(:final streams) ||
      ValueStreamPublisher(:final streams) =>
        _buildStreamObserver(streams),
      ValueNotifierPublisher(:final valueListenables) =>
        _buildValueListenableObserver(valueListenables),
      SignalPublisher(:final signals) => _buildSignalObserver(signals),
      MobxObservablePublisher(:final observables) =>
        _buildMobxObserver(observables),
      BeaconPublisher(:final beacons) => _buildBeaconObserver(beacons),
      CubitPublisher(:final cubits) => _buildCubitObserver(cubits),
      GetxPublisher(:final observables) => _buildGetxObserver(observables),
    };
  }

  Widget _buildStreamObserver(List<Stream<int>> streams) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchStream(streams: streams, visualize: visualize),
      ListenerType.streamBuilder =>
        _StreamBuilder(streams: streams, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a Stream',
        ),
    };
  }

  Widget _buildValueListenableObserver(
    List<ValueListenable<int>> valueListenables,
  ) {
    return switch (listenerType) {
      ListenerType.contextWatch => _ContextWatchValueListenable(
          valueListenables: valueListenables,
          visualize: visualize,
        ),
      ListenerType.listenableBuilder => _ValueListenableBuilder(
          valueListenables: valueListenables,
          visualize: visualize,
        ),
      ListenerType.valueListenableBuilder => _ValueListenableBuilder(
          valueListenables: valueListenables,
          visualize: visualize,
        ),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a ValueListenable',
        ),
    };
  }

  Widget _buildSignalObserver(List<sgnls.ReadonlySignal<int>> signals) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchSignal(signals: signals, visualize: visualize),
      ListenerType.signalsWatch =>
        _SignalsWatch(signals: signals, visualize: visualize),
      ListenerType.signalsWatchExt =>
        _SignalsWatchExt(signals: signals, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a Signal',
        ),
    };
  }

  Widget _buildBeaconObserver(List<bcn.ReadableBeacon<int>> beacons) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchBeacon(beacons: beacons, visualize: visualize),
      ListenerType.beaconWatchExt =>
        _BeaconsWatchExt(beacons: beacons, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a Beacon',
        ),
    };
  }

  Widget _buildMobxObserver(List<mobx.Observable<int>> observables) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchMobx(observables: observables, visualize: visualize),
      ListenerType.mobxObserver =>
        _MobxObserver(observables: observables, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a mobx.Observable',
        ),
    };
  }

  Widget _buildCubitObserver(List<bloc.Cubit<int>> cubits) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchCubit(cubits: cubits, visualize: visualize),
      ListenerType.blocBuilder =>
        _BlocBuilder(cubits: cubits, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a Cubit',
        ),
    };
  }

  Widget _buildGetxObserver(List<getx.Rx<int>> observables) {
    return switch (listenerType) {
      ListenerType.contextWatch =>
        _ContextWatchGetx(observables: observables, visualize: visualize),
      ListenerType.getxObx =>
        _GetxObx(observables: observables, visualize: visualize),
      _ => throw UnsupportedError(
          'ListenerType $listenerType is not supported for a getx.Rx',
        ),
    };
  }
}

class _ContextWatchValueListenable extends StatelessWidget {
  const _ContextWatchValueListenable({
    super.key,
    required this.valueListenables,
    required this.visualize,
  });

  final List<ValueListenable<int>> valueListenables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    int? colorIndex = valueListenables.firstOrNull?.watch(context);
    int? scaleIndex = valueListenables.secondOrNull?.watch(context);
    for (final valueListenable in valueListenables.skip(2)) {
      valueListenable.watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ContextWatchStream extends StatelessWidget {
  const _ContextWatchStream({
    super.key,
    required this.streams,
    required this.visualize,
  });

  final List<Stream<int>> streams;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<int>? colorIndexSnapshot =
        streams.firstOrNull?.watch(context);
    AsyncSnapshot<int>? scaleIndexSnapshot =
        streams.secondOrNull?.watch(context);
    for (final stream in streams.skip(2)) {
      stream.watch(context);
    }
    return _buildAsyncSnapshot(
      colorIndexSnapshot: colorIndexSnapshot,
      scaleIndexSnapshot: scaleIndexSnapshot,
      visualize: visualize,
    );
  }
}

class _ContextWatchSignal extends StatelessWidget {
  const _ContextWatchSignal({
    super.key,
    required this.signals,
    required this.visualize,
  });

  final List<sgnls.ReadonlySignal<int>> signals;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex =
        SignalContextWatchExtension(signals.firstOrNull)?.watch(context);
    final scaleIndex =
        SignalContextWatchExtension(signals.secondOrNull)?.watch(context);
    for (final signal in signals.skip(2)) {
      SignalContextWatchExtension(signal).watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ContextWatchBeacon extends StatelessWidget {
  const _ContextWatchBeacon({
    super.key,
    required this.beacons,
    required this.visualize,
  });

  final List<bcn.ReadableBeacon<int>> beacons;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex =
        BeaconContextWatchExtension(beacons.firstOrNull)?.watch(context);
    final scaleIndex =
        BeaconContextWatchExtension(beacons.secondOrNull)?.watch(context);
    for (final signal in beacons.skip(2)) {
      BeaconContextWatchExtension(signal).watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ContextWatchMobx extends StatelessWidget {
  const _ContextWatchMobx({
    super.key,
    required this.observables,
    required this.visualize,
  });

  final List<mobx.Observable<int>> observables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex = observables.firstOrNull?.watch(context);
    final scaleIndex = observables.secondOrNull?.watch(context);
    for (final observable in observables.skip(2)) {
      observable.watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ContextWatchCubit extends StatelessWidget {
  const _ContextWatchCubit({
    super.key,
    required this.cubits,
    required this.visualize,
  });

  final List<bloc.Cubit<int>> cubits;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex = cubits.firstOrNull?.watch(context);
    final scaleIndex = cubits.secondOrNull?.watch(context);
    for (final observable in cubits.skip(2)) {
      observable.watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ContextWatchGetx extends StatelessWidget {
  const _ContextWatchGetx({
    super.key,
    required this.observables,
    required this.visualize,
  });

  final List<getx.Rx<int>> observables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex = observables.firstOrNull?.watch(context);
    final scaleIndex = observables.secondOrNull?.watch(context);
    for (final observable in observables.skip(2)) {
      observable.watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _ListenableBuilder extends StatelessWidget {
  const _ListenableBuilder({
    super.key,
    required this.listenables,
    required this.visualize,
  });

  final List<Listenable> listenables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: listenables.firstOrNull ?? const _ConstValueListenable(-1),
      builder: (context, child) {
        return ListenableBuilder(
          listenable:
              listenables.secondOrNull ?? const _ConstValueListenable(-1),
          builder: (context, child) {
            Widget child = _buildFromValues(
              colorIndex: null,
              scaleIndex: null,
              visualize: visualize,
            );
            for (final listenable in listenables.skip(2)) {
              final currentChild = child;
              child = ListenableBuilder(
                listenable: listenable,
                builder: (context, child) => currentChild,
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class _ValueListenableBuilder extends StatelessWidget {
  const _ValueListenableBuilder({
    super.key,
    required this.valueListenables,
    required this.visualize,
  });

  final List<ValueListenable<int>> valueListenables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          valueListenables.firstOrNull ?? const _ConstValueListenable(-1),
      builder: (context, colorIndex, child) {
        return ValueListenableBuilder(
          valueListenable:
              valueListenables.secondOrNull ?? const _ConstValueListenable(-1),
          builder: (context, scaleIndex, child) {
            Widget child = _buildFromValues(
              colorIndex: colorIndex,
              scaleIndex: scaleIndex,
              visualize: visualize,
            );
            for (final valueListenable in valueListenables.skip(2)) {
              final currentChild = child;
              child = ValueListenableBuilder(
                valueListenable: valueListenable,
                builder: (context, snapshot, child) => currentChild,
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class _StreamBuilder extends StatelessWidget {
  const _StreamBuilder({
    super.key,
    required this.streams,
    required this.visualize,
  });

  final List<Stream<int>> streams;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streams.firstOrNull,
      builder: (context, snapshot) {
        final colorIndexSnapshot = snapshot;
        return StreamBuilder(
          stream: streams.secondOrNull,
          builder: (context, snapshot) {
            final scaleIndexSnapshot = snapshot;
            Widget child = _buildAsyncSnapshot(
              colorIndexSnapshot: colorIndexSnapshot,
              scaleIndexSnapshot: scaleIndexSnapshot,
              visualize: visualize,
            );
            for (final stream in streams.skip(2)) {
              final currentChild = child;
              child = StreamBuilder(
                stream: stream,
                builder: (context, snapshot) => currentChild,
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class _SignalsWatch extends StatelessWidget {
  const _SignalsWatch({
    super.key,
    required this.signals,
    required this.visualize,
  });

  final List<sgnls.ReadonlySignal<int>> signals;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return sgnls.Watch((context) {
      final colorIndex = signals.firstOrNull?.value;
      final scaleIndex = signals.secondOrNull?.value;
      for (final signal in signals.skip(2)) {
        signal.value;
      }
      return _buildFromValues(
        colorIndex: colorIndex,
        scaleIndex: scaleIndex,
        visualize: visualize,
      );
    });
  }
}

class _SignalsWatchExt extends StatelessWidget {
  const _SignalsWatchExt({
    super.key,
    required this.signals,
    required this.visualize,
  });

  final List<sgnls.ReadonlySignal<int>> signals;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex =
        sgnls.FlutterReadonlySignalUtils(signals.firstOrNull)?.watch(context);
    final scaleIndex =
        sgnls.FlutterReadonlySignalUtils(signals.secondOrNull)?.watch(context);
    for (final signal in signals.skip(2)) {
      sgnls.FlutterReadonlySignalUtils(signal).watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _BeaconsWatchExt extends StatelessWidget {
  const _BeaconsWatchExt({
    super.key,
    required this.beacons,
    required this.visualize,
  });

  final List<bcn.ReadableBeacon<int>> beacons;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    final colorIndex = beacons.firstOrNull?.watch(context);
    final scaleIndex = beacons.secondOrNull?.watch(context);
    for (final signal in beacons.skip(2)) {
      signal.watch(context);
    }
    return _buildFromValues(
      colorIndex: colorIndex,
      scaleIndex: scaleIndex,
      visualize: visualize,
    );
  }
}

class _MobxObserver extends StatelessWidget {
  const _MobxObserver({
    super.key,
    required this.observables,
    required this.visualize,
  });

  final List<mobx.Observable<int>> observables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return mobx.Observer(
      builder: (context) {
        final colorIndex = observables.firstOrNull?.value;
        final scaleIndex = observables.secondOrNull?.value;
        for (final observable in observables.skip(2)) {
          observable.value;
        }
        return _buildFromValues(
          colorIndex: colorIndex,
          scaleIndex: scaleIndex,
          visualize: visualize,
        );
      },
    );
  }
}

class _FallbackCubit extends bloc.Cubit<int> {
  _FallbackCubit(super.initialState);

  static final instance = _FallbackCubit(-1);
}

class _BlocBuilder extends StatelessWidget {
  const _BlocBuilder({
    super.key,
    required this.cubits,
    required this.visualize,
  });

  final List<bloc.Cubit<int>> cubits;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<bloc.Cubit<int>, int>(
      bloc: cubits.firstOrNull ?? _FallbackCubit.instance,
      builder: (context, colorIndex) {
        return bloc.BlocBuilder<bloc.Cubit<int>, int>(
          bloc: cubits.secondOrNull ?? _FallbackCubit.instance,
          builder: (context, scaleIndex) {
            Widget child = _buildFromValues(
              colorIndex: colorIndex,
              scaleIndex: scaleIndex,
              visualize: visualize,
            );
            for (final cubit in cubits.skip(2)) {
              final currentChild = child;
              child = bloc.BlocBuilder<bloc.Cubit<int>, int>(
                bloc: cubit,
                builder: (context, value) => currentChild,
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class _GetxObx extends StatelessWidget {
  const _GetxObx({
    super.key,
    required this.observables,
    required this.visualize,
  });

  final List<getx.Rx<int>> observables;
  final bool visualize;

  @override
  Widget build(BuildContext context) {
    return getx.Obx(() {
      final colorIndex = observables.firstOrNull?.value;
      final scaleIndex = observables.secondOrNull?.value;
      for (final observable in observables.skip(2)) {
        observable.value;
      }
      return _buildFromValues(
        colorIndex: colorIndex,
        scaleIndex: scaleIndex,
        visualize: visualize,
      );
    });
  }
}

Widget _buildAsyncSnapshot({
  required AsyncSnapshot<int>? colorIndexSnapshot,
  required AsyncSnapshot<int>? scaleIndexSnapshot,
  required bool visualize,
}) {
  if (!visualize) {
    return const SizedBox.shrink();
  }

  const loadingColor = Color(0xFFFFFACA);

  final child = switch (colorIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final colorIndex) =>
      ColoredBox(color: _colors[colorIndex % _colors.length]),
    AsyncSnapshot(hasError: false) => const ColoredBox(color: loadingColor),
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
    null => ColoredBox(color: Colors.grey.shade300),
  };

  final scaledChild = switch (scaleIndexSnapshot) {
    AsyncSnapshot(hasData: true, requireData: final scaleIndex) =>
      Transform.scale(
        scale: _scales[scaleIndex % _scales.length],
        child: child,
      ),
    AsyncSnapshot(hasError: false) => child,
    AsyncSnapshot(hasError: true) => const ColoredBox(color: Colors.red),
    null => child,
  };

  return scaledChild;
}

Widget _buildFromValues({
  required int? colorIndex,
  required int? scaleIndex,
  required bool visualize,
}) {
  if (!visualize) {
    return const SizedBox.shrink();
  }

  final child = switch (colorIndex) {
    -1 || null => ColoredBox(color: Colors.grey.shade300),
    int() => ColoredBox(color: _colors[colorIndex % _colors.length]),
  };

  final scaledChild = switch (scaleIndex) {
    -1 || null => child,
    int() => Transform.scale(
        scale: _scales[scaleIndex % _scales.length],
        child: child,
      ),
  };

  return scaledChild;
}

final _colors = _generateGradient(Colors.white, Colors.grey.shade400, 32);
List<Color> _generateGradient(Color startColor, Color endColor, int steps) {
  List<Color> gradientColors = [];
  int halfSteps = steps ~/ 2; // integer division to get half the steps
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    gradientColors.add(Color.lerp(startColor, endColor, t)!);
  }
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    gradientColors.add(Color.lerp(endColor, startColor, t)!);
  }
  return gradientColors;
}

final _scales = _generateScales(0.5, 0.9, 32);
List<double> _generateScales(double startScale, double endScale, int steps) {
  List<double> scales = [];
  int halfSteps = steps ~/ 2; // integer division to get half the steps
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    scales.add(startScale + (endScale - startScale) * t);
  }
  for (int i = 0; i < halfSteps; i++) {
    double t = i / (halfSteps - 1);
    scales.add(endScale + (startScale - endScale) * t);
  }
  return scales;
}

extension _ListExtensions<T> on List<T> {
  T? get firstOrNull => length > 0 ? this[0] : null;
  T? get secondOrNull => length > 1 ? this[1] : null;
}

class _ConstValueListenable<T> implements ValueListenable<T> {
  const _ConstValueListenable(this.value);

  @override
  final T value;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
