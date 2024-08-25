// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt33<T0> on (ValueListenable<T0>, Listenable, Listenable) {
  /// {@macro mass_watch_explanation}
  (T0, void, void) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context) as Null,);
}
