import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt153<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends Listenable, T3, TListenable4 extends ValueListenable<T5>, T5> on (TListenable0, TListenable2, Future<T3>, TListenable4) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, AsyncSnapshot<T3>, T5) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
