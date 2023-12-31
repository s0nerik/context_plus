import 'package:context_ref/context_ref.dart';
import 'package:context_use/context_use.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final class ContextPlus {
  ContextPlus._();

  static Widget root({
    Key? key,
    List<ContextWatcher> additionalWatchers = const [],
    required Widget child,
  }) {
    return ContextUse.root(
      child: ContextRef.root(
        child: ContextWatch.root(
          child: child,
        ),
      ),
    );
  }

  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) =>
      ContextRef.onError(handler);

  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) =>
      ContextRef.errorWidgetBuilder(builder);
}
