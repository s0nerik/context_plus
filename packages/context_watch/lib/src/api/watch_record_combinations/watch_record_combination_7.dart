import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt7<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2
>
    on (TListenable0, Stream<T2>) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
  );
}
