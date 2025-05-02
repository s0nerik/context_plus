import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt27<TListenable0 extends Listenable, T1, T2>
    on (TListenable0, Future<T1>, Stream<T2>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, AsyncSnapshot<T2>) watch(
    BuildContext context,
  ) => ($1.watch(context), $2.watch(context), $3.watch(context));
}
