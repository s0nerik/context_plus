import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt209<T0, TListenable1 extends Listenable, TListenable2 extends Listenable, TListenable3 extends ValueListenable<T4>, T4> on (Future<T0>, TListenable1, TListenable2, TListenable3) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, TListenable2, T4) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
