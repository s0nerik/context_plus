// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt163<T0, T1, T3> on (
  ValueListenable<T0>,
  ValueListenable<T1>,
  Listenable,
  Future<T3>
) {
  /// {@macro mass_watch_explanation}
  (T0, T1, void, AsyncSnapshot<T3>) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watchValue(context),
        $3.watch(context) as Null,
        $4.watch(context),
      );
}
