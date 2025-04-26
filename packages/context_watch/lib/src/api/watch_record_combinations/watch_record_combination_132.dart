import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../listenable.dart';
import '../stream.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt132<TListenable0 extends Listenable, T1, TListenable2 extends ValueListenable<T3>, T3, TListenable4 extends Listenable> on (TListenable0, Stream<T1>, TListenable2, TListenable4) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>, T3, TListenable4) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context), $3.watch(context), $4.watch(context),);
}
