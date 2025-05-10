import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt205<TListenable0 extends ValueListenable<T1>, T1, T2, T3, TListenable4 extends ValueListenable<T5>, T5> on (TListenable0, Stream<T2>, Stream<T3>, TListenable4) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, T5) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
