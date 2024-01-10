import 'package:context_ref/context_ref.dart' as ref;
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

export 'package:context_ref/context_ref.dart' hide ContextRefExt;
export 'package:context_watch/context_watch.dart';

final class ContextPlus {
  ContextPlus._();

  /// A widget that manages all [ref.Ref] values and `observable.watch()`
  /// subscriptions.
  ///
  /// This widget must be placed above all widgets that use [ref.Ref] or
  /// `observable.watch(context)`, usually at the top of the widget tree.
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

  /// [FlutterError.onError] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with more user-friendly ones.
  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) =>
      ref.ContextRef.onError(handler);

  /// [ErrorWidget.builder] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with a more user-friendly error
  /// message.
  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) =>
      ref.ContextRef.errorWidgetBuilder(builder);
}

extension RefContextWatchExt<T> on ref.Ref<T> {
  /// Get the value of this [ref.Ref] from the given [context].
  T of(BuildContext context) {
    context.unwatch();
    return ref.ContextRefExt(this).of(context);
  }
}

extension RefListenableWatchExt on ref.Ref<Listenable> {
  /// Watch this [Listenable] for changes.
  ///
  /// Whenever this [Listenable] notifies of a change, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  void watch(BuildContext context) => of(context).watch(context);
}

extension RefValueListenableWatchExt<T> on ref.Ref<ValueListenable<T>> {
  /// Watch this [ValueListenable] for changes.
  ///
  /// Whenever this [ValueListenable] notifies of a change, the [context] will
  /// be rebuilt.
  ///
  /// Returns the current value of the [ValueListenable].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) => of(context).watch(context);
}

extension RefFutureWatchExt<T> on ref.Ref<Future<T>> {
  /// Watch this [Future] for changes.
  ///
  /// When this [Future] completes, the [context] will be rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}

extension RefStreamWatchExt<T> on ref.Ref<Stream<T>> {
  /// Watch this [Stream] for changes.
  ///
  /// Whenever this [Stream] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// If this [Stream] is a [ValueStream], the initial value will be used
  /// as the initial value of the [AsyncSnapshot].
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  AsyncSnapshot<T> watch(BuildContext context) => of(context).watch(context);
}
