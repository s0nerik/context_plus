// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt273<T0> on (Stream<T0>, Listenable, Listenable, Listenable) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void, void, void) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context) as Null, $4.watch(context) as Null,);
}
