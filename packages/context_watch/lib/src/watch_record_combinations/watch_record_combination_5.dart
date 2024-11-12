// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt5<T0> on (ValueListenable<T0>, Listenable) {
  /// {@macro mass_watch_explanation}
  (T0, void) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watch(context) as Null,
      );
}
