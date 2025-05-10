import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt197<TListenable0 extends ValueListenable<T1>, T1, T2, TListenable3 extends ValueListenable<T4>, T4, TListenable5 extends ValueListenable<T6>, T6> on (TListenable0, Stream<T2>, TListenable3, TListenable5) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, T4, T6) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
