import 'package:context_watch/src/inherited_listenable_context_watch.dart';
import 'package:context_watch/src/inherited_stream_context_watch.dart';
import 'package:flutter/widgets.dart';

extension ContextUnwatchExtension on BuildContext {
  /// A workaround for https://github.com/flutter/flutter/issues/106549#issue-1283582212
  ///
  /// Use this on the first line of your build method if you specify
  /// conditional observable watchers.
  ///
  /// This will ensure that any previously-specified observable subscriptions
  /// are canceled before the new subscriptions are created via
  /// `context.watch()` down the line.
  ///
  /// Example:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   context.unwatch();
  ///   if (condition) {
  ///     context.watch(observable);
  ///   }
  /// }
  /// ```
  void unwatch() {
    dependOnInheritedWidgetOfExactType<InheritedListenableContextWatch>(
      aspect: null,
    );
    dependOnInheritedWidgetOfExactType<InheritedStreamContextWatch>(
      aspect: null,
    );
  }
}
