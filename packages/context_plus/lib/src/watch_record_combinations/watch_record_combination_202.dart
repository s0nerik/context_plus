import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt202<TListenable0 extends ValueListenable<T1>, T1, T2, T3, T4> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<Stream<T2>>, context_ref.ReadOnlyRef<Future<T3>>, context_ref.ReadOnlyRef<Future<T4>>) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, AsyncSnapshot<T3>, AsyncSnapshot<T4>) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context), $3.of(context).watch(context), $4.of(context).watch(context),);
}
