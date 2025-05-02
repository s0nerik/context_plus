import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt112<
  TListenable0 extends Listenable,
  T1,
  TListenable2 extends Listenable,
  TListenable3 extends Listenable
>
    on (TListenable0, Future<T1>, TListenable2, TListenable3) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, TListenable2, TListenable3) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
