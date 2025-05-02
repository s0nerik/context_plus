import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt167<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5,
  T6
>
    on (TListenable0, TListenable2, TListenable4, Stream<T6>) {
  /// {@macro mass_watch_explanation}
  (T1, T3, T5, AsyncSnapshot<T6>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
