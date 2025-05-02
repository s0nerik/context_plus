import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt64<
  T0,
  TListenable1 extends Listenable,
  TListenable2 extends Listenable
>
    on (Stream<T0>, TListenable1, TListenable2) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, TListenable2) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context));
}
