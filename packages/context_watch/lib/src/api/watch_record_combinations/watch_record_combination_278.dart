import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt278<
  T0,
  TListenable1 extends Listenable,
  TListenable2 extends ValueListenable<T3>,
  T3,
  T4
>
    on (Stream<T0>, TListenable1, TListenable2, Future<T4>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, T3, AsyncSnapshot<T4>) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
