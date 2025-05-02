import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt3<TListenable0 extends Listenable, T1>
    on
        (
          context_ref.ReadOnlyRef<TListenable0>,
          context_ref.ReadOnlyRef<Stream<T1>>,
        ) {
  /// {@macro mass_watch_explanation}
  (TListenable0, AsyncSnapshot<T1>) watch(BuildContext context) => (
    $1.of(context).watch(context),
    $2.of(context).watch(context),
  );
}
