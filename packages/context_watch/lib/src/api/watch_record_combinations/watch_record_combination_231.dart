import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../future.dart';
import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt231<T0, TListenable1 extends ValueListenable<T2>, T2, TListenable3 extends ValueListenable<T4>, T4, T5> on (Future<T0>, TListenable1, TListenable3, Stream<T5>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T2, T4, AsyncSnapshot<T5>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
