// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt9<T0> on (context_ref.ReadOnlyRef<Future<T0>>, context_ref.ReadOnlyRef<Listenable>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context) as Null,);
}
