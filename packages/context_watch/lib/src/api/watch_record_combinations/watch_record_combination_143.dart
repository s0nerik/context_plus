import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt143<TListenable0 extends Listenable, T1, T2, T3>
    on (TListenable0, Stream<T1>, Stream<T2>, Stream<T3>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>, AsyncSnapshot<T3>) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
