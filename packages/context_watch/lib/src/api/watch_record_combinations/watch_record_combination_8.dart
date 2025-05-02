import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt8<T0, TListenable1 extends Listenable>
    on (Future<T0>, TListenable1) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
  );
}
