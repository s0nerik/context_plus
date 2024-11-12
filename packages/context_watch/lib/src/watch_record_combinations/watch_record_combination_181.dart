// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt181<T0, T1, T2> on (
  ValueListenable<T0>,
  Future<T1>,
  ValueListenable<T2>,
  Listenable
) {
  /// {@macro mass_watch_explanation}
  (T0, AsyncSnapshot<T1>, T2, void) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watch(context),
        $3.watchValue(context),
        $4.watch(context) as Null,
      );
}
