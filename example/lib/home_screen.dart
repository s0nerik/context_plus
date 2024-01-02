import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('context_plus'),
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
              child: const Text('(context_watch) Benchmark'),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/hot_reload_test'),
              child: const Text('(context_watch) Hot Reload Test'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/bind_example'),
              child: const Text('(context_ref) Ref.bind() Example'),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/bind_value_example'),
              child: const Text('(context_ref) Ref.bindValue() Example'),
            ),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/nested_scopes_example'),
              child: const Text('(context_ref) Nested Scopes Example'),
            ),
          ],
        ),
      ),
    );
  }
}
