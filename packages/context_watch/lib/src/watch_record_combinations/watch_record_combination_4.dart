// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt4<T1> on (Listenable, Stream<T1>) {
  /// {@macro mass_watch_explanation}
  (void, AsyncSnapshot<T1>) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context),);
}
