import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'src/context_ref_root.dart';
import 'src/hot_reload.dart';

export 'src/ref.dart';

class ContextRef {
  static Widget root({
    Key? key,
    required Widget child,
  }) =>
      ContextRefRoot(child: child);

  static FlutterExceptionHandler? onError(FlutterExceptionHandler? handler) {
    if (!kDebugMode) {
      return handler;
    }
    return (details) {
      final error =
          RefGenericTypeRenamedHotReloadError.create(details.exception);
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

  static ErrorWidgetBuilder errorWidgetBuilder(ErrorWidgetBuilder builder) {
    if (!kDebugMode) {
      return builder;
    }
    return (details) {
      final error =
          RefGenericTypeRenamedHotReloadError.create(details.exception);
      if (error == null) {
        return builder(details);
      }
      return builder(details.copyWith(exception: error));
    };
  }
}
