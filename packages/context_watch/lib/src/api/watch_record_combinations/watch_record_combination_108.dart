import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt108<
  TListenable0 extends Listenable,
  TListenable1 extends ValueListenable<T2>,
  T2,
  T3,
  TListenable4 extends Listenable
>
    on (TListenable0, TListenable1, Stream<T3>, TListenable4) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2, AsyncSnapshot<T3>, TListenable4) watch(
    BuildContext context,
  ) => (
    $1.watch(context),
    $2.watch(context),
    $3.watch(context),
    $4.watch(context),
  );
}
