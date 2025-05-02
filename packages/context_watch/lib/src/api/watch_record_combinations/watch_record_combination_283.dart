import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt283<T0, TListenable1 extends Listenable, T2, T3>
    on (Stream<T0>, TListenable1, Future<T2>, Stream<T3>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>, AsyncSnapshot<T3>) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
