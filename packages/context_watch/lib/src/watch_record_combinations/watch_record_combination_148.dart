// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';
import '../watchers/stream_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt148<T0, T3> on (ValueListenable<T0>, Listenable, Listenable, Stream<T3>) {
  /// {@macro mass_watch_explanation}
  (T0, void, void, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context) as Null, $4.watch(context),);
}
