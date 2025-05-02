import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt229<
  T0,
  TListenable1 extends ValueListenable<T2>,
  T2,
  TListenable3 extends ValueListenable<T4>,
  T4,
  TListenable5 extends ValueListenable<T6>,
  T6
>
    on
        (
          context_ref.ReadOnlyRef<Future<T0>>,
          context_ref.ReadOnlyRef<TListenable1>,
          context_ref.ReadOnlyRef<TListenable3>,
          context_ref.ReadOnlyRef<TListenable5>,
        ) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, T2, T4, T6) watch(BuildContext context) => (
    $1.of(context).watch(context),
    $2.of(context).watch(context),
    $3.of(context).watch(context),
    $4.of(context).watch(context),
  );
}
