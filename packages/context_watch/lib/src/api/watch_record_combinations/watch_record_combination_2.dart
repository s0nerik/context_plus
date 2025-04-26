import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt2<TListenable0 extends Listenable, T1> on (TListenable0, Future<T1>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context),);
}
