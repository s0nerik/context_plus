import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';

class LintTestWidget extends StatelessWidget {
  const LintTestWidget({super.key});

  static final _e = Ref<String>();
  static final _stringRef = Ref<String>();
  static final _intRef = Ref<int>();
  static final _intNotifierRef = Ref<ValueNotifier<int>>();
  static final _listOfListOfStringRef = Ref<List<List<String>>>();

  static final _reassignedRef1 = Ref<String>();
  static final _reassignedRef2 = Ref<String>();

  @override
  Widget build(BuildContext context) {
    //
    // Valid uses:
    //

    // First `use` is always valid
    final a = context.use(() => 'a');

    // Different type
    final b = context.use(() => 1);

    // Same type, different key #1
    final c = context.use(() => 'c', key: 'c');

    // Same type, different key #2
    final d = context.use(() => 'd', key: 'd');

    // Same type, different ref
    final e = context.use(() => 'e', ref: _e);

    // Different type and key
    context.use(() => Object(), key: 'Object');

    //
    // Invalid uses (should trigger lint):
    //

    // Duplicate of 'a' (same type, no key, no ref)
    // expect_lint: context_use_unique_key
    final a1 = context.use(() => 'a1');

    // Duplicate of 'b' (same type, no key, no ref)
    // expect_lint: context_use_unique_key
    final b1 = context.use(() => 2);

    // Duplicate of 'c' (same type, same key)
    // expect_lint: context_use_unique_key
    final c1 = context.use(() => 'c1', key: 'c');

    // Duplicate of 'd' (same type, same key)
    // expect_lint: context_use_unique_key
    final d1 = context.use(() => 'd1', key: 'd');

    // Duplicate of 'Object' (same type, same key)
    // expect_lint: context_use_unique_key
    context.use(() => Object(), key: 'Object');

    // Duplicate of 'Object' above (same type, same key),
    // even though the key string literal uses "" instead of ''.
    // expect_lint: context_use_unique_key
    context.use(() => Object(), key: "Object");

    //
    // Other lints:
    //

    // Attempt to re-assign the `_e` ref
    // expect_lint: context_ref_reassignment, wrong_ref_type
    final e1 = context.use(() => Object(), ref: _e);

    _reassignedRef1.bind(context, () => '1');
    // expect_lint: context_ref_reassignment
    context(() => '11', ref: _reassignedRef1);

    context.use(() => '2', ref: _reassignedRef2);
    // expect_lint: context_ref_reassignment
    _reassignedRef2.bindValue(context, '2');

    // expect_lint: wrong_ref_declaration
    final ref1 = Ref(); // ignore: unused_local_variable
    // expect_lint: wrong_ref_declaration
    var ref2 = Ref(); // ignore: unused_local_variable
    // expect_lint: wrong_ref_declaration
    late final Ref ref3; // ignore: unused_local_variable

    // expect_lint: wrong_ref_type
    context.use(() => 1, ref: _stringRef);
    // expect_lint: wrong_ref_type
    context.use(() => 'Hey', ref: _intRef);
    // expect_lint: wrong_ref_type
    context.use(() => ValueNotifier('Hey'), ref: _intNotifierRef);
    // expect_lint: wrong_ref_type
    context.use(() => List.of([0]), ref: _listOfListOfStringRef);

    return Column(
      children: [
        Text('A: $a, A1: $a1'),
        Text('B: $b, B1: $b1'),
        Text('C: $c, C1: $c1'),
        Text('D: $d, D1: $d1'),
        Text('E: $e, E1: $e1'),
      ],
    );
  }
}

class TestClass {
  // expect_lint: wrong_ref_declaration
  final ref = Ref<Object>();
  // expect_lint: wrong_ref_declaration
  late final Ref ref2;
}
