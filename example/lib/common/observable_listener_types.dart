sealed class ObservableType {
  List<ListenerType> get listenerTypes;
  String get displayName;

  static List<ObservableType> get values => [
        ...FutureObservableType.values,
        ...StreamObservableType.values,
        ...ListenableObservableType.values,
        ...OtherObservableType.values,
      ];
}

sealed class ListenerType {
  String get displayName;
}

// region Future
enum FutureObservableType implements ObservableType {
  future,
  synchronousFuture;

  @override
  List<ListenerType> get listenerTypes => FutureListenerType.values;

  @override
  String get displayName => switch (this) {
        FutureObservableType.future => 'Future',
        FutureObservableType.synchronousFuture => 'SynchronousFuture',
      };
}

enum FutureListenerType implements ListenerType {
  contextWatch,
  futureBuilder;

  @override
  String get displayName => switch (this) {
        FutureListenerType.contextWatch => 'Future.watch(context)',
        FutureListenerType.futureBuilder => 'FutureBuilder',
      };
}
// endregion

// region Stream
enum StreamObservableType implements ObservableType {
  stream,
  valueStream;

  @override
  List<ListenerType> get listenerTypes => StreamListenerType.values;

  @override
  String get displayName => switch (this) {
        StreamObservableType.stream => 'Stream',
        StreamObservableType.valueStream => 'ValueStream',
      };
}

enum StreamListenerType implements ListenerType {
  contextWatch,
  streamBuilder;

  @override
  String get displayName => switch (this) {
        StreamListenerType.contextWatch => 'Stream.watch(context)',
        StreamListenerType.streamBuilder => 'StreamBuilder',
      };
}
// endregion

// region Listenable
enum ListenableObservableType implements ObservableType {
  listenable,
  valueListenable;

  @override
  List<ListenerType> get listenerTypes => switch (this) {
        ListenableObservableType.listenable => ListenableListenerType.values,
        ListenableObservableType.valueListenable =>
          ValueListenableListenerType.values,
      } as List<ListenerType>;

  @override
  String get displayName => switch (this) {
        ListenableObservableType.listenable => 'Listenable',
        ListenableObservableType.valueListenable => 'ValueListenable',
      };
}

enum ListenableListenerType implements ListenerType {
  contextWatch,
  listenableBuilder;

  @override
  String get displayName => switch (this) {
        ListenableListenerType.contextWatch => 'Listenable.watch(context)',
        ListenableListenerType.listenableBuilder => 'ListenableBuilder',
      };
}

enum ValueListenableListenerType implements ListenerType {
  contextWatch,
  listenableBuilder,
  valueListenableBuilder;

  @override
  String get displayName => switch (this) {
        ValueListenableListenerType.contextWatch =>
          'ValueListenable.watch(context)',
        ValueListenableListenerType.listenableBuilder => 'ListenableBuilder',
        ValueListenableListenerType.valueListenableBuilder =>
          'ValueListenableBuilder',
      };
}
// endregion

// region Other
enum OtherObservableType implements ObservableType {
  signal;

  @override
  List<ListenerType> get listenerTypes => switch (this) {
        OtherObservableType.signal => SignalListenerType.values,
      } as List<ListenerType>;

  @override
  String get displayName => switch (this) {
        OtherObservableType.signal => 'Signal',
      };
}

enum SignalListenerType implements ListenerType {
  contextWatch,
  signalsWatch,
  signalsWatchExt;

  @override
  String get displayName => switch (this) {
        SignalListenerType.contextWatch =>
          'Signal.watch(context) (from context_watch)',
        SignalListenerType.signalsWatchExt =>
          'Signal.watch(context) (from signals)',
        SignalListenerType.signalsWatch => 'signals.watch',
      };
}

// endregion
