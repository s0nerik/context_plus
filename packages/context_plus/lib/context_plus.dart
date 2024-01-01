import 'package:context_ref/context_ref.dart' as ref;
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

export 'package:context_ref/context_ref.dart' hide ContextRefExt;
export 'package:context_watch/context_watch.dart';

final class ContextPlus {
  ContextPlus._();

  static Widget root({
    Key? key,
    List<ContextWatcher> additionalWatchers = const [],
    required Widget child,
  }) {
    return ref.ContextRef.root(
      child: ContextWatch.root(
        child: child,
      ),
    );
  }

  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) =>
      ref.ContextRef.onError(handler);

  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) =>
      ref.ContextRef.errorWidgetBuilder(builder);
}

extension RefContextWatchExt<T> on ref.Ref<T> {
  T of(BuildContext context) {
    context.unwatch();
    return ref.ContextRefExt(this).of(context);
  }
}

extension RefListenableWatchExt on ref.Ref<Listenable> {
  void watch(BuildContext context) => of(context).watch(context);
}

extension RefValueListenableWatchExt<T> on ref.Ref<ValueListenable<T>> {
  T watch(BuildContext context) => of(context).watch(context);
}

extension RefFutureWatchExt<T> on ref.Ref<Future<T>> {
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension RefStreamWatchExt<T> on ref.Ref<Stream<T>> {
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}
