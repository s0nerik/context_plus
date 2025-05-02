import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt146<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends Listenable,
  TListenable3 extends Listenable,
  T4
>
    on (TListenable0, TListenable2, TListenable3, Future<T4>) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, TListenable3, AsyncSnapshot<T4>) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
