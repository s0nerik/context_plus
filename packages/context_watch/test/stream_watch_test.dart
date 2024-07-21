// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:context_watch/src/watchers/stream_context_watcher.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  testWidgets(
    'Stream.watch(context) gives new AsyncSnapshot after each stream event',
    (widgetTester) async {
      final streamController = StreamController<int>();
      final stream = streamController.stream;
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatch.root(
        child: Builder(
          builder: (context) {
            final snapshot = stream.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );
      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
      ]);

      streamController.add(0);
      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
      ]);

      streamController.add(1);
      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
        const AsyncSnapshot.withData(ConnectionState.active, 1),
      ]);

      streamController.close();
      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
        const AsyncSnapshot.withData(ConnectionState.active, 1),
        const AsyncSnapshot.withData(ConnectionState.done, 1),
      ]);
    },
  );

  testWidgets(
    'ValueStream.watch(context) gives AsyncSnapshot.withData right away if it has value',
    (widgetTester) async {
      final streamController = BehaviorSubject<int>.seeded(0);

      final Stream<int> stream = streamController.stream;
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatch.root(
        child: Builder(
          builder: (context) {
            final snapshot = stream.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );

      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        const AsyncSnapshot.withData(ConnectionState.waiting, 0),
      ]);

      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        const AsyncSnapshot.withData(ConnectionState.waiting, 0),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
      ]);
    },
  );

  testWidgets(
    'ValueStream.watch(context) gives AsyncSnapshot.withError right away if it has error',
    (widgetTester) async {
      final error = Exception('error');

      final streamController = BehaviorSubject<int>();
      streamController.addError(error);

      final Stream<int> stream = streamController.stream;
      final snapshots = <AsyncSnapshot<int>>[];
      final widget = ContextWatch.root(
        child: Builder(
          builder: (context) {
            final snapshot = stream.watch(context);
            snapshots.add(snapshot);
            return const SizedBox.shrink();
          },
        ),
      );

      await widgetTester.pumpWidget(widget);
      expect(snapshots, [
        AsyncSnapshot.withError(ConnectionState.waiting, error),
      ]);

      await widgetTester.pumpAndSettle();
      expect(snapshots, [
        AsyncSnapshot.withError(ConnectionState.waiting, error),
        AsyncSnapshot.withError(ConnectionState.active, error),
      ]);
    },
  );

  testWidgets(
    'Any stream (including single-subscription) can be observed multiple times for the same context',
    (widgetTester) async {
      final streamController = StreamController<int>();
      final stream = streamController.stream;
      final snapshots1 = <AsyncSnapshot<int>>[];
      final snapshots2 = <AsyncSnapshot<int>>[];
      final widget = ContextWatch.root(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                snapshots1.add(stream.watch(context));
                snapshots2.add(stream.watch(context));
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      );

      await widgetTester.pumpWidget(widget);
      expect(snapshots1, [
        const AsyncSnapshot.waiting(),
      ]);
      expect(snapshots2, [
        const AsyncSnapshot.waiting(),
      ]);

      streamController.add(0);
      await widgetTester.pumpAndSettle();
      expect(snapshots1, equals(snapshots2));
      expect(snapshots1, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
      ]);
      expect(snapshots2, [
        const AsyncSnapshot.waiting(),
        const AsyncSnapshot.withData(ConnectionState.active, 0),
      ]);
    },
  );

  group('SupportValueStream', () {
    test('recognizes latest rxdart ValueStream', () {
      // uses whatever rxdart version is currently available
      final subject = BehaviorSubject<int>();
      subject.hasValue;
      // ignore: unnecessary_type_check
      expect(subject is ValueStream<int>, isTrue);
      final stream = SupportValueStream.cast(subject.stream);
      expect(stream, isNotNull);
    });

    group('rxdart 0.27.x/0.28.x', () {
      test('hasValue does not exist', () {
        final stream = SupportValueStream27to28(_AnyOtherStream());
        expect(() => stream.hasValue, throwsNoSuchMethodError);
      });
      test('hasValue wrong type', () {
        final stream =
            SupportValueStream27to28(_SupportValueStream_hasValueWrongType());
        expect(() => stream.hasValue, throwsStateError);
      });
      test('value does not exist', () {
        final stream = SupportValueStream27to28(_AnyOtherStream());
        expect(() => stream.value, throwsNoSuchMethodError);
      });
      test('value wrong type', () {
        final stream =
            SupportValueStream27to28(_SupportValueStream_valueWrongType());
        expect(() => stream.value, throwsStateError);
      });
      test('hasError does not exist', () {
        final stream = SupportValueStream27to28(_AnyOtherStream());
        expect(() => stream.hasError, throwsNoSuchMethodError);
      });
      test('hasError wrong type', () {
        final stream =
            SupportValueStream27to28(_SupportValueStream_hasErrorWrongType());
        expect(() => stream.hasError, throwsStateError);
      });
      test('error does not exist', () {
        final stream = SupportValueStream27to28(_AnyOtherStream());
        expect(() => stream.error, throwsNoSuchMethodError);
      });
      test('error wrong type', () {
        final stream =
            SupportValueStream27to28(_SupportValueStream_errorWrongType());
        expect(() => stream.error, throwsStateError);
      });
      test('stackTrace does not exist', () {
        final stream = SupportValueStream27to28(_AnyOtherStream());
        expect(() => stream.stackTrace, throwsNoSuchMethodError);
      });
      test('stackTrace wrong type', () {
        final stream =
            SupportValueStream27to28(_SupportValueStream_stacktraceWrongType());
        expect(() => stream.stackTrace, throwsStateError);
      });
    });

    group('rxdart 0.26.x', () {
      test('valueWrapper does not exist', () {
        final stream = SupportValueStream26(_AnyOtherStream());
        expect(() => stream.valueWrapper, throwsNoSuchMethodError);
      });
      test('valueWrapper wrong type', () {
        final stream =
            SupportValueStream26(_SupportValueStream_valueWrapperWrongType());
        expect(() => stream.valueWrapper, throwsNoSuchMethodError);
      });
      test('valueWrapper.value does not exist', () {
        final stream =
            SupportValueStream26(_SupportValueStream_valueWrapperMissesValue());
        expect(() => stream.valueWrapper, throwsNoSuchMethodError);
      });
      test('valueWrapper.value wrong type', () {
        final stream = SupportValueStream26(
            _SupportValueStream_valueWrapperValueWrongType());
        expect(() => stream.valueWrapper, throwsStateError);
      });
      test('errorAndStackTrace does not exist', () {
        final stream = SupportValueStream26(_AnyOtherStream());
        expect(() => stream.errorAndStackTrace, throwsNoSuchMethodError);
      });
      test('errorAndStackTrace wrong type', () {
        final stream = SupportValueStream26(
            _SupportValueStream_errorAndStackTraceWrongType());
        expect(() => stream.errorAndStackTrace, throwsNoSuchMethodError);
      });
      test('errorAndStackTrace.stackTrace wrong type', () {
        final stream = SupportValueStream26(
            _SupportValueStream_errorAndStackTrace_StackTraceWrongType());
        expect(() => stream.errorAndStackTrace, throwsStateError);
      });
      test('errorAndStackTrace.error wrong type', () {
        final stream = SupportValueStream26(
            _SupportValueStream_errorAndStackTrace_ErrorWrongType());
        expect(() => stream.errorAndStackTrace, throwsStateError);
      });
    });
  });
}

class _AnyOtherStream<T> extends _UnimplementedStream<T> {}

class _SupportValueStream_hasValueWrongType<T> extends _UnimplementedStream<T> {
  String get hasValue => 'no'; // expects bool
}

class _SupportValueStream_valueWrongType extends _UnimplementedStream<int> {
  String get value => 'no'; // expects T (int)
}

class _SupportValueStream_hasErrorWrongType<T> extends _UnimplementedStream<T> {
  String get hasError => 'no'; // expects bool
}

class _SupportValueStream_errorWrongType<T> extends _UnimplementedStream<T> {
  Object? get error => null; // expects Object
}

class _SupportValueStream_stacktraceWrongType<T>
    extends _UnimplementedStream<T> {
  String get stackTrace => 'no'; // expects StackTrace?
}

class _SupportValueStream_valueWrapperWrongType<T>
    extends _UnimplementedStream<T> {
  String get valueWrapper => 'no'; // expects ValueWrapper
}

class _SupportValueStream_valueWrapperMissesValue<T>
    extends _UnimplementedStream<T> {
  dynamic get valueWrapper => Object(); // expects ValueWrapper with .value
}

class _SupportValueStream_valueWrapperValueWrongType
    extends _UnimplementedStream<int> {
  dynamic get valueWrapper =>
      _ValueWrapper_ValueWrongType(); // expects ValueWrapper
}

class _ValueWrapper_ValueWrongType {
  String get value => 'no'; // expects int
}

class _SupportValueStream_errorAndStackTraceWrongType<T>
    extends _UnimplementedStream<T> {
  String get errorAndStackTrace => 'no'; // expects ErrorAndStackTrace
}

class _SupportValueStream_errorAndStackTrace_ErrorWrongType<T>
    extends _UnimplementedStream<T> {
  dynamic get errorAndStackTrace => _ErrorAndStackTrace_ErrorWrongType();
}

class _ErrorAndStackTrace_ErrorWrongType {
  Object? get error => null; // expects Object
  StackTrace get stackTrace => StackTrace.current;
}

class _SupportValueStream_errorAndStackTrace_StackTraceWrongType<T>
    extends _UnimplementedStream<T> {
  dynamic get errorAndStackTrace => _ErrorAndStackTrace_StackTraceWrongType();
}

class _ErrorAndStackTrace_StackTraceWrongType {
  Object get error => Object();
  String get stackTrace => 'no'; // expects StackTrace
}

class _UnimplementedStream<T> extends Stream<T> {
  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    throw UnimplementedError();
  }
}
