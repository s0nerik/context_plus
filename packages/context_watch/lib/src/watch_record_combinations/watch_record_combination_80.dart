// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt80<T0, T1, T2> on (Stream<T0>, Stream<T1>, Stream<T2>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context),);
}
