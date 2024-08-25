// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt116<T1, T3> on (Listenable, Future<T1>, Listenable, Stream<T3>) {
  /// {@macro mass_watch_explanation}
  (void, AsyncSnapshot<T1>, void, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context), $3.watch(context) as Null, $4.watch(context),);
}
