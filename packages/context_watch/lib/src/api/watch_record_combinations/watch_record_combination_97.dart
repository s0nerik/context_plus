import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt97<
  TListenable0 extends Listenable,
  TListenable1 extends ValueListenable<T2>,
  T2,
  TListenable3 extends Listenable,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (TListenable0, TListenable1, TListenable3, TListenable4) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2, TListenable3, T5) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
