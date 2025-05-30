import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt172<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends ValueListenable<T3>, T3, T4, TListenable5 extends Listenable> on (TListenable0, TListenable2, Stream<T4>, TListenable5) {
  /// {@macro mass_watch_explanation}
  (T1, T3, AsyncSnapshot<T4>, TListenable5) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
