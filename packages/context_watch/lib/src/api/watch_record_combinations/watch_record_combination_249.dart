import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt249<
  T0,
  T1,
  T2,
  TListenable3 extends ValueListenable<T4>,
  T4
>
    on (Future<T0>, Future<T1>, Future<T2>, TListenable3) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, AsyncSnapshot<T2>, T4) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
