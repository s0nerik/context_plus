enum ObservableType {
  future,
  synchronousFuture,
  stream,
  valueStream,
  valueListenable,
  signal,
  beacon,
  mobxObservable,
  cubit,
  getRx;

  String get displayName => switch (this) {
        ObservableType.future => 'Future',
        ObservableType.synchronousFuture => 'SynchronousFuture',
        ObservableType.stream => 'Stream',
        ObservableType.valueStream => 'ValueStream',
        ObservableType.valueListenable => 'ValueListenable',
        ObservableType.signal => 'Signal',
        ObservableType.beacon => 'Beacon',
        ObservableType.mobxObservable => 'mobx.Observable',
        ObservableType.cubit => 'bloc.Cubit',
        ObservableType.getRx => 'getx.Rx',
      };

  List<ListenerType> get listenerTypes {
    return switch (this) {
      ObservableType.future => const [
          ListenerType.contextWatch,
          ListenerType.futureBuilder,
        ],
      ObservableType.synchronousFuture => const [
          ListenerType.contextWatch,
          ListenerType.futureBuilder,
        ],
      ObservableType.stream => const [
          ListenerType.contextWatch,
          ListenerType.streamBuilder,
        ],
      ObservableType.valueStream => const [
          ListenerType.contextWatch,
          ListenerType.streamBuilder,
        ],
      ObservableType.valueListenable => const [
          ListenerType.contextWatch,
          ListenerType.valueListenableBuilder,
        ],
      ObservableType.signal => const [
          ListenerType.contextWatch,
          ListenerType.signalsWatch,
          ListenerType.signalsWatchExt,
        ],
      ObservableType.beacon => const [
          ListenerType.contextWatch,
          ListenerType.beaconWatchExt,
        ],
      ObservableType.mobxObservable => const [
          ListenerType.contextWatch,
          ListenerType.mobxObserver,
        ],
      ObservableType.cubit => const [
          ListenerType.contextWatch,
          ListenerType.blocBuilder,
        ],
      ObservableType.getRx => const [
          ListenerType.contextWatch,
          ListenerType.getxObx,
        ],
    };
  }
}

enum ListenerType {
  contextWatch,
  futureBuilder,
  streamBuilder,
  listenableBuilder,
  valueListenableBuilder,
  signalsWatch,
  signalsWatchExt,
  beaconWatchExt,
  mobxObserver,
  blocBuilder,
  getxObx;

  String displayName(ObservableType observableType) {
    return switch (this) {
      ListenerType.contextWatch => switch (observableType) {
          ObservableType.future => 'Future.watch(context)',
          ObservableType.synchronousFuture =>
            'SynchronousFuture.watch(context)',
          ObservableType.stream => 'Stream.watch(context)',
          ObservableType.valueStream => 'ValueStream.watch(context)',
          ObservableType.valueListenable => 'ValueListenable.watch(context)',
          ObservableType.signal => 'Signal.watch(context)',
          ObservableType.mobxObservable => 'mobx.Observable.watch(context)',
          ObservableType.beacon => 'Beacon.watch(context)',
          ObservableType.cubit => 'Cubit.watch(context)',
          ObservableType.getRx => 'getx.Rx.watch(context)',
        },
      ListenerType.futureBuilder => 'FutureBuilder',
      ListenerType.streamBuilder => 'StreamBuilder',
      ListenerType.listenableBuilder => 'ListenableBuilder',
      ListenerType.valueListenableBuilder => 'ValueListenableBuilder',
      ListenerType.signalsWatch => 'signals: Watch',
      ListenerType.signalsWatchExt => 'signals: Signal.watch(context)',
      ListenerType.mobxObserver => 'mobx: Observer',
      ListenerType.beaconWatchExt => 'beacon: Beacon.watch(context)',
      ListenerType.blocBuilder => 'bloc: BlocBuilder',
      ListenerType.getxObx => 'getx: Obx',
    };
  }
}
