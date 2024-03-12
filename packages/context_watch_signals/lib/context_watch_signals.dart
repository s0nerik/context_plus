import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;

export 'src/signal_context_watcher.dart';

export 'package:signals_flutter/signals_flutter.dart'
    hide FlutterReadonlySignalUtils;

/// Overrides some of the [signals.FlutterReadonlySignalUtils] extensions
/// to replace observing methods with context_watch-based ones.
///
/// Other extensions are proxied to the original ones, with the original doc
/// comments copied over.
extension FlutterReadonlySignalUtils<T> on signals.ReadonlySignal<T> {
  /// Used to listen for updates on a signal but not rebuild the nearest element
  ///
  /// ```dart
  /// final counter = signal(0);
  /// ...
  /// @override
  /// Widget build(BuildContext context) {
  ///   counter.listen(context, () {
  ///     if (counter.value == 10) {
  ///       final messenger = ScaffoldMessenger.of(context);
  ///       messenger.hideCurrentSnackBar();
  ///       messenger.showSnackBar(
  ///         const SnackBar(content: Text('You hit 10 clicks!')),
  ///       );
  ///     }
  ///   });
  /// ...
  /// }
  /// ```
  void listen(
    BuildContext context,
    void Function() callback, {
    String? debugLabel,
  }) =>
      signals.FlutterReadonlySignalUtils(this)
          .listen(context, callback, debugLabel: debugLabel);

  /// Convert a signal to [ValueListenable] to be used in builders
  /// and other existing widgets like [ValueListenableBuilder]
  ValueListenable<T> toValueListenable() {
    final notifier = ValueNotifier(this());
    subscribe((v) => notifier.value = v);
    onDispose(notifier.dispose);
    return notifier;
  }
}
