// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt161<T0, T1> on (
  ValueListenable<T0>,
  ValueListenable<T1>,
  Listenable,
  Listenable
) {
  /// {@macro mass_watch_explanation}
  (T0, T1, void, void) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watchValue(context),
        $3.watch(context) as Null,
        $4.watch(context) as Null,
      );
}
