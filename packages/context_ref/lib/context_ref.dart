import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'src/context_ref_root.dart';
import 'src/hot_reload.dart';
import 'src/ref.dart';

export 'src/context_ticker_provider.dart' show ContextTickerProviderExt;
export 'src/context_use.dart';
export 'src/ref.dart' hide InternalReadOnlyRefAPI;
export 'src/special_cases/vsync_ref_api.dart';

class ContextRef {
  /// A widget that manages all [Ref] values and subscriptions.
  ///
  /// This widget must be placed above all widgets that use [Ref], usually at
  /// the top of the widget tree.
  static Widget root({Key? key, required Widget child}) =>
      ContextRefRoot(child: child);

  /// [FlutterError.onError] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with more user-friendly ones.
  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) {
    if (!kDebugMode) {
      return handler;
    }
    return (details) {
      final error = RefGenericTypeRenamedHotReloadError.create(
        details.exception,
      );
      if (error == null) {
        handler?.call(details);
        return;
      }
      developer.log(
        'Hot reload is impossible. Do a hot restart instead. See https://docs.flutter.dev/tools/hot-reload#generic-types for more details.',
        name: 'context_ref',
        level: 2000,
        error: error,
      );
    };
  }

  /// [ErrorWidget.builder] wrapper that replaces common hot_reload-related
  /// errors (such as generic type rename error) with a more user-friendly error
  /// message.
  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) {
    if (!kDebugMode) {
      return builder;
    }
    return (details) {
      final error = RefGenericTypeRenamedHotReloadError.create(
        details.exception,
      );
      if (error == null) {
        return builder(details);
      }
      return builder(details.copyWith(exception: error));
    };
  }
}
