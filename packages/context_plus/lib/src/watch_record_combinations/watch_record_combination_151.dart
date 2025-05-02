import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt151<
  TListenable0 extends ValueListenable<T1>,
  T1,
  TListenable2 extends Listenable,
  TListenable3 extends ValueListenable<T4>,
  T4,
  T5
>
    on
        (
          context_ref.ReadOnlyRef<TListenable0>,
          context_ref.ReadOnlyRef<TListenable2>,
          context_ref.ReadOnlyRef<TListenable3>,
          context_ref.ReadOnlyRef<Stream<T5>>,
        ) {
  /// {@macro mass_watch_explanation}
  (T1, TListenable2, T4, AsyncSnapshot<T5>) watch(BuildContext context) => (
    $1.of(context).watch(context),
    $2.of(context).watch(context),
    $3.of(context).watch(context),
    $4.of(context).watch(context),
  );
}
