import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt48<T0, TListenable1 extends Listenable, TListenable2 extends Listenable> on (Future<T0>, TListenable1, TListenable2) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, TListenable2) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context),);
}
