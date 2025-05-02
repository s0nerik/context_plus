import 'package:flutter/widgets.dart';

import '../future.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt250<T0, T1, T2, T3>
    on (Future<T0>, Future<T1>, Future<T2>, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>)
  watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
