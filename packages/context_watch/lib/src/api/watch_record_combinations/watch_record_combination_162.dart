import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt162<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  TListenable4 extends Listenable,
  T5
>
    on (TListenable0, TListenable2, TListenable4, Future<T5>) {
  /// {@macro mass_watch_explanation}
  (T1, T3, TListenable4, AsyncSnapshot<T5>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
