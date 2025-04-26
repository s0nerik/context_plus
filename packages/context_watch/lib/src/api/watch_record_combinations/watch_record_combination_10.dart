import 'package:flutter/widgets.dart';

import '../future.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt10<T0, T1> on (Future<T0>, Future<T1>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context),);
}
