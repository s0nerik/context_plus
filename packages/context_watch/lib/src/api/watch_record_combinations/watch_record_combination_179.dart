import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt179<
  TListenable0 extends ValueListenable<T1>,
  T1,
  T2,
  TListenable3 extends Listenable,
  T4
>
    on (TListenable0, Future<T2>, TListenable3, Stream<T4>) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, TListenable3, AsyncSnapshot<T4>) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
