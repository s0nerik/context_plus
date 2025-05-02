import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt213<
  T0,
  TListenable1 extends Listenable,
  TListenable2 extends ValueListenable<T3>,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (Future<T0>, TListenable1, TListenable2, TListenable4) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, T3, T5) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
