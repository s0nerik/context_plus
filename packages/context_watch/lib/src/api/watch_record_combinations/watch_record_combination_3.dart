import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt3<TListenable0 extends Listenable, T1>
    on (TListenable0, Stream<T1>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
  );
}
