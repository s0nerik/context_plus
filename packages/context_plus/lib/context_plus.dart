import 'package:context_ref_watch/context_ref_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

export 'package:context_ref_watch/context_ref_watch.dart'
    hide ContextRef, ContextWatch;

final class ContextPlus {
  ContextPlus._();

  static Widget root({
    Key? key,
    List<ContextWatcher> additionalWatchers = const [],
    required Widget child,
  }) {
    return ContextRef.root(
      child: ContextWatch.root(
        child: child,
      ),
    );
  }

  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) =>
      ContextRef.onError(handler);

  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) =>
      ContextRef.errorWidgetBuilder(builder);
}
