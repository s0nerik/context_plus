import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt216<
  T0,
  TListenable1 extends Listenable,
  T2,
  TListenable3 extends Listenable
>
    on (Future<T0>, TListenable1, Future<T2>, TListenable3) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>, TListenable3) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
