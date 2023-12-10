import 'package:context_watch/context_watch.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:example/common/observable_publishers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart' as signals;

import 'observable_listener_types.dart';

class ObservableObserver extends StatelessWidget {
  const ObservableObserver({
    super.key,
    required this.publisher,
    required this.listenerType,
  });

  final ObservablePublisher publisher;
  final ListenerType listenerType;

  @override
  Widget build(BuildContext context) {
    return switch (publisher) {
      StreamPublisher(:final stream) => _buildStreamObserver(stream),
      ValueStreamPublisher(:final stream) => _buildStreamObserver(stream),
      ValueNotifierPublisher(:final valueListenable) =>
        _buildValueListenableObserver(valueListenable),
      SignalPublisher(:final signal) => _buildSignalObserver(signal),
    };
  }

  Widget _buildStreamObserver(Stream<int> stream) {
    return switch (listenerType as StreamListenerType) {
      StreamListenerType.contextWatch => _ContextWatchStream(stream: stream),
      StreamListenerType.streamBuilder => _StreamBuilder(stream: stream)
    };
  }

  Widget _buildValueListenableObserver(ValueListenable<int> valueListenable) {
    return switch (listenerType as ValueListenableListenerType) {
      ValueListenableListenerType.contextWatch =>
        _ContextWatchValueListenable(valueListenable: valueListenable),
      ValueListenableListenerType.listenableBuilder =>
        _ValueListenableBuilder(valueListenable: valueListenable),
      ValueListenableListenerType.valueListenableBuilder =>
        _ValueListenableBuilder(valueListenable: valueListenable),
    };
  }

  Widget _buildSignalObserver(signals.Signal<int> signal) {
    return switch (listenerType as SignalListenerType) {
      SignalListenerType.contextWatch => _ContextWatchSignal(signal: signal),
      SignalListenerType.signalsWatch => _SignalsWatch(signal: signal),
      SignalListenerType.signalsWatchExt => _SignalsWatchExt(signal: signal),
    };
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
