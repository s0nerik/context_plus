import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt49<T0, TListenable1 extends Listenable, TListenable2 extends ValueListenable<T3>, T3> on (context_ref.ReadOnlyRef<Future<T0>>, context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<TListenable2>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, TListenable1, T3) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context), $3.of(context).watch(context),);
}
