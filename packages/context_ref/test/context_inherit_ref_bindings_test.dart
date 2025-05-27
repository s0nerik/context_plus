import 'package:context_ref/context_ref.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  testWidgets(
    'inheritRefBindingsFrom allows to access other context\'s bindings',
    (tester) async {
      final ref = Ref<ValueNotifier<int>>();
      await pumpWidget(tester, (context) {
        ref.bind(context, () => ValueNotifier(0));
        return ElevatedButton(
          onPressed: () {
            final parentContext = context;
            showDialog(
              context: context,
              builder: (context) {
                context.inheritRefBindingsFrom(parentContext);
                final observedValue = ref.of(context).watch(context);
                return AlertDialog(
                  content: Text('Observed value: $observedValue'),
                );
              },
            );
          },
          child: const Text('Show Dialog'),
        );
      });

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Observed value: 0'), findsOneWidget);
    },
  );

  testWidgets(
    'without inheritRefBindingsFrom, the dialogs cannot access the parent context\'s bindings',
    (tester) async {
      final ref = Ref<ValueNotifier<int>>();
      await pumpWidget(tester, (context) {
        ref.bind(context, () => ValueNotifier(0));
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final observedValue = ref.of(context).watch(context);
                return AlertDialog(
                  content: Text('Observed value: $observedValue'),
                );
              },
            );
          },
          child: const Text('Show Dialog'),
        );
      });

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNotNull);
    },
  );
}
