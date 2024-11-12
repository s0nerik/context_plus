// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt50<T0, T2> on (
  Future<T0>,
  Listenable,
  ValueListenable<T2>
) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void, T2) watch(BuildContext context) => (
        $1.watch(context),
        $2.watch(context) as Null,
        $3.watchValue(context),
      );
}
