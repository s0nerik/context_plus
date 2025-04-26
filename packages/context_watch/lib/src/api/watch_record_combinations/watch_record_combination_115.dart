import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt115<TListenable0 extends Listenable, T1, TListenable2 extends Listenable, T3> on (TListenable0, Future<T1>, TListenable2, Stream<T3>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, TListenable2, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
