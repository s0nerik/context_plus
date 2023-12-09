import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('context_watch'),
      ),
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/benchmark'),
              child: const Text('Benchmark'),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/hot_reload_test'),
              child: const Text('Hot Reload Test'),
            ),
          ],
        ),
      ),
    );
  }
}
