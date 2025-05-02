import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt70<
  T0,
  TListenable1 extends ValueListenable<T2>,
  T2,
  T3
>
    on (Stream<T0>, TListenable1, Future<T3>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T2, AsyncSnapshot<T3>) watch(BuildContext context) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
  );
}
