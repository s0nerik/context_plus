import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt5<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends ValueListenable<T3>, T3> on (TListenable0, TListenable2) {
  /// {@macro mass_watch_explanation}
  (T1, T3) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context),);
}
