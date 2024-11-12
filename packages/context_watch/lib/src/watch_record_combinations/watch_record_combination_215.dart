// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt215<T0, T2, T3> on (
  Future<T0>,
  Listenable,
  ValueListenable<T2>,
  Future<T3>
) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void, T2, AsyncSnapshot<T3>) watch(
          BuildContext context) =>
      (
        $1.watch(context),
        $2.watch(context) as Null,
        $3.watchValue(context),
        $4.watch(context),
      );
}
