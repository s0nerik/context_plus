// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt83<T3> on (Listenable, Listenable, Listenable, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (void, void, void, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context) as Null, $3.watch(context) as Null, $4.watch(context),);
}
