import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int widgetRebuilds;
  late int bindClosureInvocations;
  late Widget widget;
  late List<ValueNotifier<int>> dependencyValueNotifiers;
  late Ref<int> derivedSumValueRef;
  late int lastProvidedDerivedSumValue;
  late int lastObservedDerivedSumValue;

  setUp(() {
    dependencyValueNotifiers = [];
    widgetRebuilds = 0;
    bindClosureInvocations = 0;
    derivedSumValueRef = Ref();
    final childWidget = Builder(
      builder: (context) {
        lastObservedDerivedSumValue = derivedSumValueRef.of(context);
        return const SizedBox.shrink();
      },
    );
    widget = ContextPlus.root(
      child: Builder(
        builder: (context) {
          widgetRebuilds++;
          derivedSumValueRef.bind(context, (context) {
            bindClosureInvocations++;
            int sum = 0;
            for (final listenable in dependencyValueNotifiers) {
              final value = listenable.watch(context);
              sum += value;
            }
            lastProvidedDerivedSumValue = sum;
            return sum;
          });
          return childWidget;
        },
      ),
    );
  });

  group('watch() inside bind()', () {
    testWidgets('does_not rebuild widget when dependency value changes',
        (tester) async {
      dependencyValueNotifiers = [
        ValueNotifier(1),
      ];
      await tester.pumpWidget(widget);
      expect(widgetRebuilds, 1);
      expect(lastProvidedDerivedSumValue, 1);
      expect(bindClosureInvocations, 1);

      dependencyValueNotifiers[0].value = 2;
      await tester.pump();
      dependencyValueNotifiers[0].value = 2;
      await tester.pump();
      dependencyValueNotifiers[0].value = 3;
      await tester.pump();
      expect(widgetRebuilds, 1);
      expect(bindClosureInvocations, 3);
      expect(lastObservedDerivedSumValue, 3);
      expect(lastProvidedDerivedSumValue, 3);
    });
  });
}
