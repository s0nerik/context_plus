import 'package:flutter/material.dart';

class ContextWatchExampleScreen extends StatelessWidget {
  const ContextWatchExampleScreen({super.key});

  static const title = 'Anything.watch()';
  static const urlPath = '/context_watch_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const Placeholder(),
    );
  }
}
