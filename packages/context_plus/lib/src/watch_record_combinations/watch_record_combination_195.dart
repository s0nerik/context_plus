import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt195<TListenable0 extends ValueListenable<T1>, T1, T2, TListenable3 extends Listenable, T4> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<Stream<T2>>, context_ref.ReadOnlyRef<TListenable3>, context_ref.ReadOnlyRef<Stream<T4>>) {
  /// {@macro mass_watch_explanation}
  (T1, AsyncSnapshot<T2>, TListenable3, AsyncSnapshot<T4>) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context), $3.of(context).watch(context), $4.of(context).watch(context),);
}
