import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

import 'src/context_watch_root.dart';

export 'package:context_watch_base/context_watch_base.dart' show ContextWatcher;

export 'src/api/future.dart';
export 'src/api/listenable.dart';
export 'src/api/stream.dart';
export 'src/api/watch_callback_record_combinations.dart';
export 'src/api/watch_record_combinations.dart';

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
  }) => ContextWatchRoot(
    key: key,
    additionalWatchers: additionalWatchers,
    child: child,
  );
}
