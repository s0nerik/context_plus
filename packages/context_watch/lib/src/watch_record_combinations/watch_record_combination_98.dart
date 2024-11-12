// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt98<T1, T3> on (
  Listenable,
  ValueListenable<T1>,
  Listenable,
  ValueListenable<T3>
) {
  /// {@macro mass_watch_explanation}
  (void, T1, void, T3) watch(BuildContext context) => (
        $1.watch(context) as Null,
        $2.watchValue(context),
        $3.watch(context) as Null,
        $4.watchValue(context),
      );
}
