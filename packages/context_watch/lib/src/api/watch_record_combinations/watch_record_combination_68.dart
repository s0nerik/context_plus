import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt68<
  T0,
  TListenable1 extends ValueListenable<T2>,
  T2,
  TListenable3 extends Listenable
>
    on (Stream<T0>, TListenable1, TListenable3) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T2, TListenable3) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
  );
}
