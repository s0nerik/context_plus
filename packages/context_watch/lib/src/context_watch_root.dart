import 'dart:math';

import 'package:context_plus_core/context_plus_core.dart';
import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'watchers/future_context_watcher.dart';
import 'watchers/listenable_context_watcher.dart';
import 'watchers/stream_context_watcher.dart';
import 'watchers/value_listenable_context_watcher.dart';

@internal
class ContextWatchRoot extends StatefulWidget {
  const ContextWatchRoot({
    super.key,
    this.additionalWatchers = const [],
    required this.child,
  });

  final List<ContextWatcher> additionalWatchers;
  final Widget child;

  @override
  State<ContextWatchRoot> createState() => _ContextWatchRootState();
}

class _ContextWatchRootState extends State<ContextWatchRoot> {
  late List<ContextWatcher?> _watchers;
  void _updateWatchers() {
    var lastAdditionalWatcherIndex = 0;
    if (widget.additionalWatchers.length > 1) {
      lastAdditionalWatcherIndex = widget.additionalWatchers
          .map((e) => e.type.index)
          .reduce((a, b) => a > b ? a : b);
    } else if (widget.additionalWatchers.length == 1) {
      lastAdditionalWatcherIndex = widget.additionalWatchers.first.type.index;
    }
    _watchers = List.filled(
      max(
        lastAdditionalWatcherIndex + 1,
        ContextWatcherObservableType.values.length,
      ),
      null,
      growable: false,
    );
    for (final watcherType in ContextWatcherObservableType.values) {
      _watchers[watcherType.index] = switch (watcherType) {
        ContextWatcherObservableType.listenable => ListenableContextWatcher(),
        ContextWatcherObservableType.valueListenable =>
          ValueListenableContextWatcher(),
        ContextWatcherObservableType.stream => StreamContextWatcher(),
        ContextWatcherObservableType.future => FutureContextWatcher(),
        _ => null,
      };
    }
    for (final watcher in widget.additionalWatchers) {
      _watchers[watcher.type.index] = watcher;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateWatchers();
  }

  @override
  void didUpdateWidget(covariant ContextWatchRoot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.additionalWatchers, oldWidget.additionalWatchers)) {
      _updateWatchers();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ElementDataHolder.maybeOf(context) == null) {
      return ElementDataHolder.scope(
        child: InheritedContextWatch(watchers: _watchers, child: widget.child),
      );
    }
    return InheritedContextWatch(watchers: _watchers, child: widget.child);
  }
}
