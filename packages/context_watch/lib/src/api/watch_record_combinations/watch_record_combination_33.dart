import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt33<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends Listenable,
  TListenable3 extends ValueListenable<T4>,
  T4
>
    on (TListenable0, TListenable2, TListenable3) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, T4) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
  );
}
