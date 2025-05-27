import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<(ValueListenable<int> rebuilds, StateSetter setState)> pumpWidget(
  WidgetTester tester,
  WidgetBuilder builder,
) async {
  final rebuilds = ValueNotifier<int>(0);
  late StateSetter resultSetState;
  await tester.pumpWidget(
    ContextWatch.root(
      child: ContextRef.root(
        child: MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              resultSetState = setState;
              rebuilds.value++;
              return builder(context);
            },
          ),
        ),
      ),
    ),
  );
  return (rebuilds, resultSetState);
}

class Value<T> {
  Value(this.value);

  final T value;

  @override
  String toString() =>
      'Value<$T>#${identityHashCode(this).toRadixString(36)}($value)';
}
