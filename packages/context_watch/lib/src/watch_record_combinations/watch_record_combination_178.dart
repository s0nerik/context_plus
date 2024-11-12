// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt178<T0, T1, T3> on (
  ValueListenable<T0>,
  Future<T1>,
  Listenable,
  ValueListenable<T3>
) {
  /// {@macro mass_watch_explanation}
  (T0, AsyncSnapshot<T1>, void, T3) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watch(context),
        $3.watch(context) as Null,
        $4.watchValue(context),
      );
}
