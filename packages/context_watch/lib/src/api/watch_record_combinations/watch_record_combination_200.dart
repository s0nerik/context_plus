import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt200<TListenable0 extends ValueListenable<T1>, T1, T2, T3, TListenable4 extends Listenable> on (TListenable0, Stream<T2>, Future<T3>, TListenable4) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, TListenable4) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
