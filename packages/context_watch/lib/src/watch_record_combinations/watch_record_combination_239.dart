// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt239<T0, T1, T2, T3> on (Future<T0>, ValueListenable<T1>, Stream<T2>, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
