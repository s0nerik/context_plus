import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt327<T0, T1, TListenable2 extends ValueListenable<T3>, T3, T4> on (context_ref.ReadOnlyRef<Stream<T0>>, context_ref.ReadOnlyRef<Stream<T1>>, context_ref.ReadOnlyRef<TListenable2>, context_ref.ReadOnlyRef<Stream<T4>>) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, AsyncSnapshot<T1>, T3, AsyncSnapshot<T4>) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context), $3.of(context).watch(context), $4.of(context).watch(context),);
}
