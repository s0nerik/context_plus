import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt192<TListenable0 extends ValueListenable<T1>, T1, T2, TListenable3 extends Listenable, TListenable4 extends Listenable> on (TListenable0, Stream<T2>, TListenable3, TListenable4) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, TListenable3, TListenable4) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
