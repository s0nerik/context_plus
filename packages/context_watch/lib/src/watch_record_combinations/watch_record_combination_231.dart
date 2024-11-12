// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt231<T0, T1, T2, T3> on (
  Future<T0>,
  ValueListenable<T1>,
  ValueListenable<T2>,
  Future<T3>
) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T1, T2, AsyncSnapshot<T3>) watch(BuildContext context) =>
      (
        $1.watch(context),
        $2.watchValue(context),
        $3.watchValue(context),
        $4.watch(context),
      );
}
