// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt157<T0, T2> on (
  ValueListenable<T0>,
  Listenable,
  Stream<T2>,
  Listenable
) {
  /// {@macro mass_watch_explanation}
  (T0, void, AsyncSnapshot<T2>, void) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watch(context) as Null,
        $3.watch(context),
        $4.watch(context) as Null,
      );
}
