import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt22<
  TListenable0 extends Listenable,
  TListenable1 extends ValueListenable<T2>,
  T2,
  T3
>
    on (TListenable0, TListenable1, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2, AsyncSnapshot<T3>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
  );
}
