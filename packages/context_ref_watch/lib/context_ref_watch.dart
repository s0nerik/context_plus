import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension RefListenableWatchExt on Ref<Listenable> {
  void watch(BuildContext context) => of(context).watch(context);
}

extension RefValueListenableWatchExt<T> on Ref<ValueListenable<T>> {
  T watch(BuildContext context) => of(context).watch(context);
}

extension RefFutureWatchExt<T> on Ref<Future<T>> {
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension RefStreamWatchExt<T> on Ref<Stream<T>> {
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}
