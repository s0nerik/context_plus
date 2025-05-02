import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt51<T0, TListenable1 extends Listenable, T2>
    on (Future<T0>, TListenable1, Stream<T2>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, AsyncSnapshot<T2>) watch(
    BuildContext context,
  ) => ($1.watch(context), $2.watch(context), $3.watch(context));
}
