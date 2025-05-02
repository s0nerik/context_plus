import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt12<T0, TListenable1 extends Listenable>
    on (Stream<T0>, TListenable1) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
  );
}
