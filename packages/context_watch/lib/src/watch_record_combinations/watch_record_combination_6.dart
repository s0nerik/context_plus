// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt6<T0, T1> on (
  ValueListenable<T0>,
  ValueListenable<T1>
) {
  /// {@macro mass_watch_explanation}
  (T0, T1) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watchValue(context),
      );
}
