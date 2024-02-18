import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

export 'package:context_ref/context_ref.dart' hide ContextRefExt;
export 'package:context_watch/context_watch.dart';

export 'src/context_ref_watch_integration.dart';

final class ContextPlus {
  ContextPlus._();

  /// A widget that manages all [Ref] values and `observable.watch()`
  /// subscriptions.
  ///
  /// This widget must be placed above all widgets that use [Ref] or
  /// `observable.watch(context)`, usually at the top of the widget tree.
  static Widget root({
    Key? key,
    List<ContextWatcher> additionalWatchers = const [],
    required Widget child,
  }) {
    return ContextRef.root(
      key: key,
      child: ContextWatch.root(
        additionalWatchers: additionalWatchers,
        child: child,
      ),
    );
  }

  /// [FlutterError.onError] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with more user-friendly ones.
  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) =>
      ContextRef.onError(handler);

  /// [ErrorWidget.builder] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with a more user-friendly error
  /// message.
  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) =>
      ContextRef.errorWidgetBuilder(builder);
}
