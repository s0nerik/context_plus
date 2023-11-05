import 'package:context_watch/src/inherited_listenable_context_watch.dart';
import 'package:context_watch/src/inherited_stream_context_watch.dart';
import 'package:flutter/widgets.dart';

/// Provides the ability to watch Listenable and Stream values using
/// `listenable.watch(context)` within a build method.
///
/// This widget should be placed at the root of the tree.
class ContextWatchRoot extends StatelessWidget {
  const ContextWatchRoot({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InheritedListenableContextWatch(
      child: InheritedStreamContextWatch(
        child: child,
      ),
    );
  }
}
