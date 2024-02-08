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
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              _Group(
                title: 'context_ref',
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/bind_example'),
                    child: const Text('Ref.bind()'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/bind_value_example'),
                    child: const Text('Ref.bindValue()'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/nested_scopes_example'),
                    child: const Text('Nested Scopes'),
                  ),
                ],
              ),
              _Group(
                title: 'context_watch',
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/benchmark'),
                    child: const Text('Benchmark'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/hot_reload_test'),
                    child: const Text('Hot Reload Test'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
