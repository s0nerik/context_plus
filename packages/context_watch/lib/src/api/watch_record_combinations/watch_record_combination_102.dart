import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt102<TListenable0 extends Listenable, TListenable1 extends ValueListenable<T2>, T2, TListenable3 extends ValueListenable<T4>, T4, T5> on (TListenable0, TListenable1, TListenable3, Future<T5>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2, T4, AsyncSnapshot<T5>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
