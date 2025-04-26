import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt25<TListenable0 extends Listenable, T1, TListenable2 extends ValueListenable<T3>, T3> on (TListenable0, Future<T1>, TListenable2) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, T3) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context),);
}
