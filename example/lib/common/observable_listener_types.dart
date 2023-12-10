sealed class ObservableType {
  List<ListenerType> get listenerTypes;
}

sealed class ListenerType {
  bool get isContextWatch;
}

// region Future
enum FutureObservableType implements ObservableType {
  future,
  synchronousFuture;

  @override
  List<ListenerType> get listenerTypes => FutureListenerType.values;
}

enum FutureListenerType implements ListenerType {
  contextWatch,
  futureBuilder;

  @override
  bool get isContextWatch => this == FutureListenerType.contextWatch;
}
// endregion

// region Stream
enum StreamObservableType implements ObservableType {
  stream,
  valueStream;

  @override
  List<ListenerType> get listenerTypes => StreamListenerType.values;
}

enum StreamListenerType implements ListenerType {
  contextWatch,
  streamBuilder;

  @override
  bool get isContextWatch => this == StreamListenerType.contextWatch;
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
}

enum ListenableListenerType implements ListenerType {
  contextWatch,
  listenableBuilder;

  @override
  bool get isContextWatch => this == ListenableListenerType.contextWatch;
}

enum ValueListenableListenerType implements ListenerType {
  contextWatch,
  listenableBuilder,
  valueListenableBuilder;

  @override
  bool get isContextWatch => this == ValueListenableListenerType.contextWatch;
}
// endregion

// region Other
enum OtherObservableType implements ObservableType {
  signal;

  @override
  List<ListenerType> get listenerTypes => switch (this) {
        OtherObservableType.signal => SignalListenerType.values,
      } as List<ListenerType>;
}

enum SignalListenerType implements ListenerType {
  contextWatch,
  signalsWatch,
  signalsWatchExt;

  @override
  bool get isContextWatch => this == SignalListenerType.contextWatch;
}

// endregion
