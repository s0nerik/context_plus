import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt1<TListenable0 extends Listenable, TListenable1 extends ValueListenable<T2>, T2> on (TListenable0, TListenable1) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context),);
}
