// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt305<T0, T1> on (Stream<T0>, Future<T1>, Listenable, Listenable) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, void, void) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context) as Null, $4.watch(context) as Null,);
}
