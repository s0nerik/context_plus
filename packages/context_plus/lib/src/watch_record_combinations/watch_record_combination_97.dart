import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordRefExt97<TListenable0 extends Listenable, TListenable1 extends ValueListenable<T2>, T2, TListenable3 extends Listenable, TListenable4 extends ValueListenable<T5>, T5> on (context_ref.ReadOnlyRef<TListenable0>, context_ref.ReadOnlyRef<TListenable1>, context_ref.ReadOnlyRef<TListenable3>, context_ref.ReadOnlyRef<TListenable4>) {
  /// {@macro mass_watch_explanation}
  (TListenable0, T2, TListenable3, T5) watch(BuildContext context) =>
      ($1.of(context).watch(context), $2.of(context).watch(context), $3.of(context).watch(context), $4.of(context).watch(context),);
}
