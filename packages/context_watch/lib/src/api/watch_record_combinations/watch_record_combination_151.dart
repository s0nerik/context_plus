import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt151<TListenable0 extends ValueListenable<T1>, T1, TListenable2 extends Listenable, TListenable3 extends ValueListenable<T4>, T4, T5> on (TListenable0, TListenable2, TListenable3, Stream<T5>) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, T4, AsyncSnapshot<T5>) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
