// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt246<T0, T1, T2, T3> on (
  Future<T0>,
  Future<T1>,
  ValueListenable<T2>,
  ValueListenable<T3>
) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, T2, T3) watch(BuildContext context) =>
      (
        $1.watch(context),
        $2.watch(context),
        $3.watchValue(context),
        $4.watchValue(context),
      );
}
