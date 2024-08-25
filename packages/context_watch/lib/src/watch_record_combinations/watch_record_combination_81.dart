// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt81 on (Listenable, Listenable, Listenable, Listenable) {
  /// {@macro mass_watch_explanation}
  (void, void, void, void) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context) as Null, $3.watch(context) as Null, $4.watch(context) as Null,);
}
