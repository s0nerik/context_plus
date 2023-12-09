import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';

extension ContextUnwatchExtension on BuildContext {
  /// Use this on the first line of your build method if you specify
  /// conditional observable watchers.
  ///
  /// This will ensure that any previously-specified observable subscriptions
  /// don't cause your widget to rebuild after you remove the calls to watch()
  /// from the build method. Actual observable subscriptions for unwatch()'ed
  /// context will be removed when the widget is unmounted or when observable
  /// notifies next event.
  ///
  /// Please note, that not calling unwatch() even if you have conditional
  /// watch()'es is totally fine. The worst thing that can happen if you don't
  /// call the unwatch() in this case, is that your widget will get rebuilt each
  /// time a no-longer-watched observable notifies of a change after ALL calls
  /// to `watch()` have been removed from the `build()` method. If this scares
  /// you, please thumbs-up [this Flutter issue](https://github.com/flutter/flutter/issues/106549),
  /// as the same exact behavior is observed using any [InheritedWidget], and
  /// is itself a performance optimization technique used in Flutter.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   context.unwatch();
  ///   if (condition) {
  ///     observable.watch(context);
  ///   }
  /// }
  /// ```
  void unwatch() {
    final watchRoot = InheritedContextWatch.of(this);
    watchRoot.updateContextLastFrame(this);
  }
}
