// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt95<T2, T3> on (Listenable, Listenable, Stream<T2>, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (void, void, AsyncSnapshot<T2>, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context) as Null, $3.watch(context), $4.watch(context),);
}
