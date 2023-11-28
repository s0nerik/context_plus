import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContextWatchRoot(
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
