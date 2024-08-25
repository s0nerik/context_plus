// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt121<T1, T2> on (Listenable, Future<T1>, Future<T2>, Listenable) {
  /// {@macro mass_watch_explanation}
  (void, AsyncSnapshot<T1>, AsyncSnapshot<T2>, void) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context), $3.watch(context), $4.watch(context) as Null,);
}
