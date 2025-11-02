import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Root widget removal disposes all bindings', (tester) async {
    final ref = Ref<_Disposable>();
    late _Disposable disposable;

    await tester.pumpWidget(
      ContextPlus.root(
        child: Builder(
          builder: (context) {
            disposable = ref.bind(
              context,
              () => _Disposable(),
              dispose: (s) => s.isDisposed = true,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    expect(disposable.isDisposed, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(disposable.isDisposed, isTrue);
  });
}

class _Disposable {
  bool isDisposed = false;
}
