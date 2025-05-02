import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt93<
  TListenable0 extends Listenable,
  TListenable1 extends Listenable,
  T2,
  TListenable3 extends ValueListenable<T4>,
  T4
>
    on (TListenable0, TListenable1, Stream<T2>, TListenable3) {
  /// {@macro mass_watch_explanation}
  (TListenable0, TListenable1, AsyncSnapshot<T2>, T4) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
