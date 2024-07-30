import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

import 'src/context_watch_root.dart';

export 'package:context_watch_base/context_watch_base.dart' show ContextWatcher;

export 'src/watchers/future_context_watcher.dart'
    show FutureContextWatchExtension, FutureContextWatchOnlyExtension;
export 'src/watchers/listenable_context_watcher.dart'
    show
        ListenableContextWatchExtension,
        ListenableContextWatchOnlyExtension,
        ValueListenableContextWatchExtension,
        AsyncListenableContextWatchExtension;
export 'src/watchers/stream_context_watcher.dart'
    show StreamContextWatchExtension, StreamContextWatchOnlyExtension;

class ContextWatch {
  /// Provides the ability to watch observable values using
  /// `observable.watch(context)` within a build method.
  ///
  /// This widget should be placed at the root of the widget tree.
  ///
  /// Provide [additionalWatchers] to add custom observable types support.
  static Widget root({
    Key? key,
    List<ContextWatcher> additionalWatchers = const [],
    required Widget child,
  }) =>
      ContextWatchRoot(
        key: key,
        additionalWatchers: additionalWatchers,
        child: child,
      );
}
