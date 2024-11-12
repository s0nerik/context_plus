// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt86<T2, T3> on (
  context_ref.ReadOnlyRef<Listenable>,
  context_ref.ReadOnlyRef<Listenable>,
  context_ref.ReadOnlyRef<ValueListenable<T2>>,
  context_ref.ReadOnlyRef<ValueListenable<T3>>
) {
  /// {@macro mass_watch_explanation}
  (void, void, T2, T3) watch(BuildContext context) => (
        $1.of(context).watch(context) as Null,
        $2.of(context).watch(context) as Null,
        $3.of(context).watchValue(context),
        $4.of(context).watchValue(context),
      );
}
