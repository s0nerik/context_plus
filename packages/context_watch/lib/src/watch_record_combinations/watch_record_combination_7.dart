// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt7<T0, T1> on (ValueListenable<T0>, Future<T1>) {
  /// {@macro mass_watch_explanation}
  (T0, AsyncSnapshot<T1>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context),);
}
