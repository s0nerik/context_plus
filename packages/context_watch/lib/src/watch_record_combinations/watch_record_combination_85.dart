// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt85<T2> on (
  Listenable,
  Listenable,
  ValueListenable<T2>,
  Listenable
) {
  /// {@macro mass_watch_explanation}
  (void, void, T2, void) watch(BuildContext context) => (
        $1.watch(context) as Null,
        $2.watch(context) as Null,
        $3.watchValue(context),
        $4.watch(context) as Null,
      );
}
