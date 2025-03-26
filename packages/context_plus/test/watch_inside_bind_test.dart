import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'no rebuilds when bind() re-invocation returns a value equal to the previous one',
      (tester) async {
    final dependency = ValueNotifier(0);
    final derivedRef = Ref<int>();
    int rebinds = 0;

    late int boundValue;
    late int returnedBoundValue;
    int rebuilds = 0;
    final widget = Builder(
      builder: (context) {
        rebuilds++;
        returnedBoundValue = derivedRef.bind(
          context,
          (context) {
            rebinds++;
            boundValue = dependency.watch(context);
            return boundValue;
          },
        );
        return const SizedBox.shrink();
      },
    );

    await tester.pumpWidget(ContextPlus.root(child: widget));
    expect(rebinds, 1);
    expect(boundValue, 0);
    expect(returnedBoundValue, 0);
    expect(rebuilds, 1);

    // dependency notifies about a new value
    dependency.value = 1;
    await tester.pump();
    expect(rebinds, 2); // bind() callback is invoked again
    expect(boundValue, 1); // bound value changes
    expect(returnedBoundValue, 1); // returned bound value changes
    expect(rebuilds, 2); // context gets rebuild

    // dependency notifies about the same value
    dependency.notifyListeners();
    await tester.pump();
    expect(rebinds, 3); // bind() callback is invoked again
    expect(boundValue, 1); // bound value is the same as before
    expect(returnedBoundValue, 1); // returned bound value is the same as before
    expect(rebuilds, 2); // context is_not rebuilt
  });

  testWidgets(
      'no rebuilds when bind() re-invocation returns the same instance as before',
      (tester) async {
    final dependency = ValueNotifier(0);
    final derivedRef = Ref<ValueNotifier<int>>();
    int rebinds = 0;

    ValueNotifier<int>? prevBoundNotifier;
    ValueNotifier<int>? boundNotifier;
    ValueNotifier<int>? returnedBoundNotifier;
    int rebuilds = 0;
    final widget = Builder(
      builder: (context) {
        rebuilds++;
        returnedBoundNotifier = derivedRef.bind(
          context,
          (context) {
            rebinds++;
            prevBoundNotifier = boundNotifier;

            final value = dependency.watch(context);
            var notifier = derivedRef.maybeOf(context);
            if (notifier == null) {
              notifier = ValueNotifier(value);
            } else {
              notifier.value = value;
            }
            boundNotifier = notifier;

            return notifier;
          },
        );
        return const SizedBox.shrink();
      },
    );

    await tester.pumpWidget(ContextPlus.root(child: widget));
    expect(rebinds, 1);
    expect(boundNotifier, isNot(prevBoundNotifier));
    expect(returnedBoundNotifier, isNot(prevBoundNotifier));
    expect(rebuilds, 1);

    // dependency notifies about a new value
    dependency.value = 1;
    await tester.pump();
    expect(rebinds, 2); // bind() callback is invoked again
    // notifier instance is the same
    expect(boundNotifier, same(prevBoundNotifier));
    // returned notifier instance is the same
    expect(returnedBoundNotifier, same(prevBoundNotifier));
    // context is_not rebuilt since the returned notifier instance is the same
    expect(rebuilds, 1);
  });

  testWidgets(
      'no dependent child rebuilds when bind() re-invocation returns a value equal to the previous one',
      (tester) async {
    final dependency = ValueNotifier(0);
    final derivedRef = Ref<int>();
    int rebinds = 0;

    int parentRebuilds = 0;
    int childRebuilds = 0;

    late int boundValue;
    late int returnedBoundValue;
    late int observedDerivedValue;

    final child = Builder(
      builder: (context) {
        childRebuilds++;
        observedDerivedValue = derivedRef.of(context);
        return const SizedBox.shrink();
      },
    );
    final parentWidget = Builder(
      builder: (context) {
        parentRebuilds++;
        returnedBoundValue = derivedRef.bind(
          context,
          (context) {
            rebinds++;
            boundValue = dependency.watch(context);
            return boundValue;
          },
        );
        return child;
      },
    );

    await tester.pumpWidget(ContextPlus.root(child: parentWidget));
    expect(rebinds, 1);
    expect(boundValue, 0);
    expect(returnedBoundValue, 0);
    expect(observedDerivedValue, 0);
    expect(parentRebuilds, 1);
    expect(childRebuilds, 1);

    // dependency notifies about a new value
    dependency.value = 1;
    await tester.pump();
    // bind() callback is invoked again due to the dependency change
    expect(rebinds, 2);
    // bound value is updated
    expect(boundValue, 1);
    // returned bound value is updated
    expect(returnedBoundValue, 1);
    // observed derived value is updated
    expect(observedDerivedValue, 1);
    // parent is rebuilt since the provided value changed
    expect(parentRebuilds, 2);
    // child is rebuilt since the dependency value changed
    expect(childRebuilds, 2);

    // dependency notifies about the same value
    dependency.notifyListeners();
    await tester.pump();
    // bind() callback is invoked again due to the dependency change
    expect(rebinds, 3);
    // bound value is the same as before
    expect(boundValue, 1);
    // returned bound value is the same as before
    expect(returnedBoundValue, 1);
    // observed derived value is the same as before
    expect(observedDerivedValue, 1);
    // parent is_not rebuilt since the provided value is the same
    expect(parentRebuilds, 2);
    // child is_not rebuilt since the dependency value is the same
    expect(childRebuilds, 2);
  });

  testWidgets(
      'no dependent child rebuilds when bind() re-invocation returns the same instance as before',
      (tester) async {
    final dependency = ValueNotifier(0);
    final derivedRef = Ref<ValueNotifier<int>>();
    int rebinds = 0;

    int parentRebuilds = 0;
    int childRebuilds = 0;

    ValueNotifier<int>? prevBoundNotifier;
    ValueNotifier<int>? boundNotifier;
    ValueNotifier<int>? returnedBoundNotifier;
    ValueNotifier<int>? observedDerivedRefNotifier;

    final child = Builder(
      builder: (context) {
        childRebuilds++;
        observedDerivedRefNotifier = derivedRef.of(context);
        return const SizedBox.shrink();
      },
    );
    final parentWidget = Builder(
      builder: (context) {
        parentRebuilds++;
        returnedBoundNotifier = derivedRef.bind(context, (context) {
          rebinds++;
          prevBoundNotifier = boundNotifier;

          final value = dependency.watch(context);
          var notifier = derivedRef.maybeOf(context);
          if (notifier == null) {
            notifier = ValueNotifier(value);
          } else {
            notifier.value = value;
          }
          boundNotifier = notifier;

          return notifier;
        });
        return child;
      },
    );

    await tester.pumpWidget(ContextPlus.root(child: parentWidget));
    expect(rebinds, 1);
    expect(boundNotifier, isNot(prevBoundNotifier));
    expect(returnedBoundNotifier, isNot(prevBoundNotifier));
    expect(observedDerivedRefNotifier, isNot(prevBoundNotifier));
    expect(parentRebuilds, 1);
    expect(childRebuilds, 1);

    // dependency notifies about a new value
    dependency.value = 1;
    await tester.pump();
    // bind() callback is invoked again due to the dependency change
    expect(rebinds, 2);
    // bound notifier instance is the same
    expect(boundNotifier, same(prevBoundNotifier));
    // returned notifier instance is the same
    expect(returnedBoundNotifier, same(prevBoundNotifier));
    // observed derived ref notifier instance is the same
    expect(observedDerivedRefNotifier, same(prevBoundNotifier));
    // parent is_not rebuilt since the provided value is the same
    expect(parentRebuilds, 1);
    // child is_not rebuilt since the dependency value is the same
    expect(childRebuilds, 1);
  });

  testWidgets(
      'dependency ref value change notification triggers the derived Ref\'s bind() callback and relevant context rebuilds',
      (tester) async {
    final dependencyRef = Ref<int>();
    final derivedRef = Ref<String>(); // dependency as String

    late int observedDependencyValue;
    late String returnedDerivedValue;
    late String observedDerivedValue;

    int dependencyValue = 0;
    late Function(Function()) setStateRoot;

    int derivedRebinds = 0;

    int rootRebuilds = 0;
    int parentRebuilds = 0;
    int childRebuilds = 0;
    final childWidget = Builder(
      builder: (context) {
        childRebuilds++;
        observedDerivedValue = derivedRef.of(context);
        return const SizedBox.shrink();
      },
    );
    final parentWidget = Builder(
      builder: (context) {
        parentRebuilds++;
        returnedDerivedValue = derivedRef.bind(context, (context) {
          derivedRebinds++;
          observedDependencyValue = dependencyRef.of(context);
          return observedDependencyValue.toString();
        });
        return childWidget;
      },
    );
    final rootWidget = StatefulBuilder(
      builder: (context, setState) {
        rootRebuilds++;
        setStateRoot = setState;
        dependencyRef.bindValue(context, dependencyValue);
        return parentWidget;
      },
    );

    await tester.pumpWidget(ContextPlus.root(child: rootWidget));
    expect(rootRebuilds, 1);
    expect(parentRebuilds, 1);
    expect(childRebuilds, 1);
    expect(derivedRebinds, 1);
    expect(observedDependencyValue, 0);
    expect(returnedDerivedValue, '0');
    expect(observedDerivedValue, '0');

    // no more frames are scheduled yet
    expect(TestWidgetsFlutterBinding.instance.hasScheduledFrame, false);

    // dependency ref value changes, bind() is invoked again
    setStateRoot(() => dependencyValue = 1);
    // allow the requested rootWidget rebuild to happen
    await tester.pump();
    // bind() callback of the derivedRef is invoked again, immediately
    expect(derivedRebinds, 2);
    // parent is_not rebuilt yet since its rebuild is scheduled for the next frame
    expect(parentRebuilds, 1);
    // the next frame is scheduled for the parentWidget rebuild
    expect(TestWidgetsFlutterBinding.instance.hasScheduledFrame, true);

    // allow the dependencyRef value change to get reflected in the widget tree
    // as the dependent widget rebuild is always scheduled for the next frame
    // if triggered inside a build() method (as it happens in rootWidget)
    await tester.pump();
    // root is rebuilt since the setState was called on it
    expect(rootRebuilds, 2);
    // parent is rebuilt since the dependency ref value changed
    expect(parentRebuilds, 2);
    // child is rebuilt since its dependency ref value changed
    expect(childRebuilds, 2);
    // dependency ref value is updated
    expect(observedDependencyValue, 1);
    // bind() returns the up-to-date derived value
    expect(returnedDerivedValue, '1');
    // observed derived value is up-to-date
    expect(observedDerivedValue, '1');
  });
}
