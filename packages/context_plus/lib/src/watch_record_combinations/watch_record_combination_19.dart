// ignore_for_file: use_of_void_result

import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt19<T2> on (context_ref.ReadOnlyRef<Listenable>, context_ref.ReadOnlyRef<Listenable>, context_ref.ReadOnlyRef<Future<T2>>) {
  /// {@macro mass_watch_explanation}
  (void, void, AsyncSnapshot<T2>) watch(BuildContext context) =>
      ($1.of(context).watch(context) as Null, $2.of(context).watch(context) as Null, $3.of(context).watch(context),);
}
