sealed class DataType {
  List<ListenerType> get listenerTypes;
}

sealed class ListenerType {
  bool get isContextWatch;
}

// region Future
enum FutureDataType implements DataType {
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
enum StreamDataType implements DataType {
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
enum ListenableDataType implements DataType {
  listenable,
  valueListenable;

  @override
  List<ListenerType> get listenerTypes => switch (this) {
        ListenableDataType.listenable => ListenableListenerType.values,
        ListenableDataType.valueListenable =>
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
enum OtherDataType implements DataType {
  signal;

  @override
  List<ListenerType> get listenerTypes => switch (this) {
        OtherDataType.signal => SignalListenerType.values,
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
