import 'package:context_watch/src/inherited_listenable_context_watch.dart';
import 'package:context_watch/src/inherited_stream_context_watch.dart';
import 'package:flutter/widgets.dart';

import 'inherited_future_context_watch.dart';

extension ContextUnwatchExtension on BuildContext {
  /// Use this on the first line of your build method if you specify
  /// conditional observable watchers.
  ///
  /// This will ensure that any previously-specified observable subscriptions
  /// are canceled before the new subscriptions are created via
  /// `context.watch()` down the line.
  ///
  /// Please note that calling this method is quite expensive (measurements
  /// show ~40% slowdown compared to not using it), so use it only if you
  /// absolutely need it.
  ///
  /// The worst thing that can happen if you don't use it is that your widget
  /// will get rebuilt each time a no-longer-watched listenable notifies of a
  /// change after all calls to `watch()` has been removed from the `build()`
  /// method. If this scares you, please thumbs-up
  /// [this Flutter issue](https://github.com/flutter/flutter/issues/106549),
  /// as the same exact behavior is observed using any [InheritedWidget].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   context.unwatch();
  ///   if (condition) {
  ///     listenable.watch(context);
  ///   }
  /// }
  /// ```
  void unwatch() {
    final listenableWatchRoot = getElementForInheritedWidgetOfExactType<
            InheritedListenableContextWatch>()
        as InheritedListenableContextWatchElement;
    listenableWatchRoot.unsubscribe(this as Element);

    final futureWatchRoot =
        getElementForInheritedWidgetOfExactType<InheritedFutureContextWatch>()
            as InheritedFutureContextWatchElement;
    futureWatchRoot.unsubscribe(this as Element);

    final streamWatchRoot =
        getElementForInheritedWidgetOfExactType<InheritedStreamContextWatch>()
            as InheritedStreamContextWatchElement;
    streamWatchRoot.unsubscribe(this as Element);
  }
}
