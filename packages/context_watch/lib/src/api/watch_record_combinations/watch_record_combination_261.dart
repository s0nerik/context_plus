import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt261<
  T0,
  T1,
  TListenable2 extends ValueListenable<T3>,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (Future<T0>, Stream<T1>, TListenable2, TListenable4) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, T5) watch(BuildContext context) =>
      (
        $1.watch(context),
        $2.watch(context),
        $3.watch(context),
        $4.watch(context),
      );
}
