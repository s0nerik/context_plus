import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int rebuilds;
  late Widget widget;
  late List<Listenable> observedListenables;
  late List<Stream> observedStreams;

  setUp(() {
    observedListenables = [];
    observedStreams = [];
    rebuilds = 0;
    widget = ContextWatch.root(
      child: Builder(
        builder: (context) {
          context.unwatch();
          for (final listenable in observedListenables) {
            // watch the value to create a subscription
            listenable.watchListenable(context);
          }
          for (final stream in observedStreams) {
            // watch the value to create a subscription
            stream.watch(context);
          }
          rebuilds++;
          return const SizedBox.shrink();
        },
      ),
    );
  });

  testWidgets(
    'widget rebuilds only once after each bunch of synchronous change notifications',
    (widgetTester) async {
      final valueNotifier = ValueNotifier('a');
      observedListenables = [valueNotifier];

      final streamController = StreamController<String>.broadcast();
      observedStreams = [streamController.stream];

      await widgetTester.pumpWidget(widget);
      expect(rebuilds, 1);

      valueNotifier.value = 'b';
      streamController.add('b');
      await widgetTester.pumpAndSettle();
      expect(rebuilds, 2);
    },
  );

  testWidgets(
    'if value.watch(context) disappears from build method, value changes do_not trigger rebuilds anymore',
    (widgetTester) async {
      final valueNotifier1 = ValueNotifier('a');
      final valueNotifier2 = ValueNotifier(0);
      observedListenables = [valueNotifier1, valueNotifier2];

      await widgetTester.pumpWidget(widget);
      expect(rebuilds, 1);

      valueNotifier1.value = 'b';
      await widgetTester.pumpAndSettle();
      expect(rebuilds, 2);

      observedListenables = [valueNotifier2];
      valueNotifier1.value = 'c';
      await widgetTester.pumpAndSettle();
      // Even though the `valueNotifier1.watch(context)` was_not called
      // during this build, it was called during the previous one, so we
      // expect a rebuild.
      expect(rebuilds, 3);

      valueNotifier1.value = 'd';
      await widgetTester.pumpAndSettle();
      // Since `valueNotifier1.watch(context)` was_not called during the
      // previous build, changing its value does_not trigger an
      // additional rebuild.
      expect(rebuilds, 3);

      valueNotifier2.value = 2;
      await widgetTester.pumpAndSettle();
      // `valueNotifier2.watch(context)` is still called during the build, so
      // changing its value triggers a rebuild.
      expect(rebuilds, 4);

      observedListenables = [];
      valueNotifier2.value = 3;
      await widgetTester.pumpAndSettle();
      // Even though neither
      // `valueNotifier1.watch(context)` or `valueNotifier2.watch(context)`
      // were called during this build, `valueNotifier2.watch(context)` was
      // called during the previous one, so we expect a rebuild.
      expect(rebuilds, 5);

      valueNotifier1.value = 'e';
      valueNotifier2.value = 4;
      await widgetTester.pumpAndSettle();
      // Since no observable values were watched during the previous build,
      // changing any observable values does_not trigger an additional rebuild.
      expect(rebuilds, 5);
    },
  );
}
