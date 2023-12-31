import 'package:context_use/context_use.dart';
import 'package:context_use/src/context_use_root.dart';
import 'package:context_watch/context_watch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'use() returns the same value, no matter how many times it is called',
      (widgetTester) async {
    var (useValue1, useValue2, useValue3) = (
      ValueNotifier(false),
      ValueNotifier(false),
      ValueNotifier(false),
    );
    final valueRecords = <(int?, int?, int?)>[];
    int generatedIndex = 0;
    final valueGenerations = [0, 0, 0];
    await widgetTester.pumpWidget(
      ContextWatch.root(
        child: ContextUseRoot(
          child: Builder(
            builder: (context) {
              var (value1, value2, value3) = (null, null, null);
              if (useValue1.watch(context)) {
                value1 = context.use<int>(() {
                  valueGenerations[0]++;
                  return generatedIndex++;
                });
              }
              if (useValue2.watch(context)) {
                value2 = context.use<int>(() {
                  valueGenerations[1]++;
                  return generatedIndex++;
                });
              }
              if (useValue3.watch(context)) {
                value3 = context.use<int>(() {
                  valueGenerations[2]++;
                  return generatedIndex++;
                });
              }
              valueRecords.add((value1, value2, value3));
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    expect(valueGenerations, [0, 0, 0]);
    expect(valueRecords, [(null, null, null)]);

    useValue1.value = true;
    await widgetTester.pump(const Duration(seconds: 1));
    expect(valueGenerations, [1, 0, 0]);
    expect(valueRecords, [
      (null, null, null),
      (0, null, null),
    ]);

    useValue2.value = true;
    await widgetTester.pump(const Duration(seconds: 1));
    expect(valueGenerations, [1, 1, 0]);
    expect(valueRecords, [
      (null, null, null),
      (0, null, null),
      (0, 1, null),
    ]);

    useValue3.value = true;
    await widgetTester.pump(const Duration(seconds: 1));
    expect(valueGenerations, [1, 1, 1]);
    expect(valueRecords, [
      (null, null, null),
      (0, null, null),
      (0, 1, null),
      (0, 1, 2),
    ]);

    useValue1.value = false;
    await widgetTester.pump(const Duration(seconds: 1));
    expect(valueGenerations, [1, 1, 1]);
    expect(valueRecords, [
      (null, null, null),
      (0, null, null),
      (0, 1, null),
      (0, 1, 2),
      // IMPORTANT:
      //
      // When conditional use() disappears from the build, the
      // usages counter doesn't increase properly, making it impossible to
      // determine which value to return.
      //
      // This case must be handled by the user of context_use, by making sure
      // that context.use() is never called conditionally.
      (null, 0, 1),
    ]);
  });
}
