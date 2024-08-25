// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt150<T0, T2, T3> on (ValueListenable<T0>, Listenable, ValueListenable<T2>, ValueListenable<T3>) {
  /// {@macro mass_watch_explanation}
  (T0, void, T2, T3) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context), $4.watch(context),);
}
