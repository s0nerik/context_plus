import 'package:flutter/widgets.dart';

import '../future.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt58<T0, T1, T2>
    on (Future<T0>, Future<T1>, Future<T2>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>) watch(
    BuildContext context,
  ) => ($1.watch(context), $2.watch(context), $3.watch(context));
}
