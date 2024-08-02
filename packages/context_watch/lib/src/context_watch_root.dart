import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'watchers/future_context_watcher.dart';
import 'watchers/listenable_context_watcher.dart';
import 'watchers/stream_context_watcher.dart';

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
  final _builtInWatchers = <ContextWatcher>[
    ListenableContextWatcher(),
    StreamContextWatcher(),
    FutureContextWatcher(),
  ];

  late List<ContextWatcher> _watchers;

  @override
  void initState() {
    super.initState();
    _watchers =
        (widget.additionalWatchers + _builtInWatchers).toList(growable: false);
  }

  @override
  void didUpdateWidget(covariant ContextWatchRoot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _watchers =
        (widget.additionalWatchers + _builtInWatchers).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedContextWatch(
      watchers: _watchers,
      child: widget.child,
    );
  }
}
