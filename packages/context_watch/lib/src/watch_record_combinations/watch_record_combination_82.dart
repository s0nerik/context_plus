// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt82<T3> on (Listenable, Listenable, Listenable, ValueListenable<T3>) {
  /// {@macro mass_watch_explanation}
  (void, void, void, T3) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context) as Null, $3.watch(context) as Null, $4.watch(context),);
}
