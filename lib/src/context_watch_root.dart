import 'package:context_watch/src/inherited_listenable_context_watch.dart';
import 'package:context_watch/src/inherited_stream_context_watch.dart';
import 'package:flutter/widgets.dart';

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
