import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt34<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends Listenable, T3> on (TListenable0, TListenable2, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, AsyncSnapshot<T3>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context),);
}
