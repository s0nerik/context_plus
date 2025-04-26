import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt18<TListenable0 extends Listenable, TListenable1 extends Listenable, T2> on (TListenable0, TListenable1, Future<T2>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, TListenable1, AsyncSnapshot<T2>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context),);
}
