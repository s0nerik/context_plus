import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt6<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2
>
    on (TListenable0, Future<T2>) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
  );
}
