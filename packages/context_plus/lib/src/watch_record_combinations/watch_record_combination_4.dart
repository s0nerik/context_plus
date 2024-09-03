// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt4<T1> on (context_ref.ReadOnlyRef<Listenable>, context_ref.ReadOnlyRef<Stream<T1>>) {
  /// {@macro mass_watch_explanation}
  (void, AsyncSnapshot<T1>) watch(BuildContext context) =>
      ($1.of(context).watch(context) as Null, $2.of(context).watch(context),);
}
