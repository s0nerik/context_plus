// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt68<T0, T2> on (Stream<T0>, Listenable, Stream<T2>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void, AsyncSnapshot<T2>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context),);
}
