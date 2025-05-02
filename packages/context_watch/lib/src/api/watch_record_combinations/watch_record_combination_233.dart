import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt233<
  T0,
  TListenable1 extends ValueListenable<T2>,
  T2,
  T3,
  TListenable4 extends ValueListenable<T5>,
  T5
>
    on (Future<T0>, TListenable1, Future<T3>, TListenable4) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>, T5) watch(BuildContext context) =>
      (
        $1.watch(context),
        $2.watch(context),
        $3.watch(context),
        $4.watch(context),
      );
}
