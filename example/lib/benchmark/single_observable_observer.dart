import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart' as signals;
import 'package:context_watch_signals/context_watch_signals.dart';

import 'benchmark_listener_type.dart';
import 'single_observable_publisher.dart';

class SingleObservableObserver extends StatelessWidget {
  const SingleObservableObserver({
    super.key,
    required this.publisher,
    required this.listenerType,
  });

  final SingleObservablePublisher publisher;
  final BenchmarkListenerType listenerType;

  @override
  Widget build(BuildContext context) {
    switch (publisher) {
      case SingleStreamPublisher(:final stream):
        switch (listenerType) {
          case BenchmarkListenerType.contextWatch:
            return _ContextWatchStream(
              stream: stream,
            );
          case BenchmarkListenerType.streamBuilder:
            return _StreamBuilder(
              stream: stream,
            );
          case BenchmarkListenerType.signalsWatch:
          case BenchmarkListenerType.signalsWatchExt:
          case BenchmarkListenerType.valueListenableBuilder:
            throw UnsupportedError('stream is not supported by $listenerType');
        }
      case SingleValueNotifierPublisher(:final valueListenable):
        switch (listenerType) {
          case BenchmarkListenerType.contextWatch:
            return _ContextWatchValueListenable(
              valueListenable: valueListenable,
            );
          case BenchmarkListenerType.valueListenableBuilder:
            return _ValueListenableBuilder(
              valueListenable: valueListenable,
            );
          case BenchmarkListenerType.signalsWatch:
          case BenchmarkListenerType.signalsWatchExt:
          case BenchmarkListenerType.streamBuilder:
            throw UnsupportedError('stream is not supported by $listenerType');
        }
      case SingleSignalPublisher(:final signal):
        switch (listenerType) {
          case BenchmarkListenerType.contextWatch:
            return _ContextWatchSignal(signal: signal);
          case BenchmarkListenerType.signalsWatch:
            return _SignalsWatch(signal: signal);
          case BenchmarkListenerType.signalsWatchExt:
            return _SignalsWatchExt(signal: signal);
          case BenchmarkListenerType.streamBuilder:
          case BenchmarkListenerType.valueListenableBuilder:
            throw UnsupportedError('signal is not supported by $listenerType');
        }
    }
  }
}

class _ContextWatchValueListenable extends StatelessWidget {
  const _ContextWatchValueListenable({
    super.key,
    required this.valueListenable,
  });

  final ValueListenable<int> valueListenable;

  @override
  Widget build(BuildContext context) {
    valueListenable.watch(context);
    return const SizedBox.shrink();
  }
}

class _ContextWatchStream extends StatelessWidget {
  const _ContextWatchStream({
    super.key,
    required this.stream,
  });

  final Stream<int> stream;

  @override
  Widget build(BuildContext context) {
    stream.watch(context);
    return const SizedBox.shrink();
  }
}

class _ContextWatchSignal extends StatelessWidget {
  const _ContextWatchSignal({
    super.key,
    required this.signal,
  });

  final signals.Signal<int> signal;

  @override
  Widget build(BuildContext context) {
    SignalContextWatchExtension(signal).watch(context);
    return const SizedBox.shrink();
  }
}

class _ValueListenableBuilder extends StatelessWidget {
  const _ValueListenableBuilder({
    super.key,
    required this.valueListenable,
  });

  final ValueListenable<int> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) => const SizedBox.shrink(),
    );
  }
}

class _StreamBuilder extends StatelessWidget {
  const _StreamBuilder({
    super.key,
    required this.stream,
  });

  final Stream<int> stream;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SignalsWatch extends StatelessWidget {
  const _SignalsWatch({
    super.key,
    required this.signal,
  });

  final signals.Signal<int> signal;

  @override
  Widget build(BuildContext context) {
    return signals.Watch((context) {
      signal.value;
      return const SizedBox.shrink();
    });
  }
}

class _SignalsWatchExt extends StatelessWidget {
  const _SignalsWatchExt({
    super.key,
    required this.signal,
  });

  final signals.Signal<int> signal;

  @override
  Widget build(BuildContext context) {
    signals.ReadonlySignalUtils(signal).watch(context);
    return const SizedBox.shrink();
  }
}
