// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt22<T1, T2> on (Listenable, ValueListenable<T1>, ValueListenable<T2>) {
  /// {@macro mass_watch_explanation}
  (void, T1, T2) watch(BuildContext context) =>
      ($1.watch(context) as Null, $2.watch(context), $3.watch(context),);
}
