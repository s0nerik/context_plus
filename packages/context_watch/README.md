# context_watch

![context_watch.png](https://github.com/s0nerik/context_plus/raw/main/doc/context_watch.png)

[![context_watch](https://img.shields.io/pub/v/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/likes/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/points/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/dm/context_watch)](https://pub.dev/packages/context_watch)

Subscribe widgets to any observable value using `observable.watch(context)`. No strings attached.

See [context_plus](https://pub.dev/packages/context_plus) for the ultimate convenience.

## Features

- `.watch(context)` - rebuild the `context` whenever the observable notifies of a change. Returns the current value or `AsyncSnapshot` for corresponding types.
- `.watchOnly(context, (...) => ...)` - rebuild the `context` whenever the observable notifies of a change, but only if selected value has changed.
- `.watchEffect(context, (...) => ...)` - execute the provided callback whenever the observable notifies of a change *without* rebuilding the `context`.
- Multi-value observing of up to 4 observables:

  ```dart
  final (value, futureSnap, streamSnap) =
      (valueListenable, future, stream).watch(context);
  ```
  
  All three methods are available for all combinations of observables.

## Supported observable types

### Built-in

- `Listenable` (`ChangeNotifier`/`ValueNotifier`/`AnimationController`/`ScrollController`/`TabController` etc.):
- `Stream`/`ValueStream`
- `Future`/`SynchronousFuture`

## Integrations

| Package                                                                                                   | Pub                                                                                                                            | Description                                                                                                                   |
|-----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| [context_watch_bloc](https://github.com/s0nerik/context_plus/tree/main/packages/context_watch_bloc)       | [![context_watch_bloc](https://img.shields.io/pub/v/context_watch_bloc)](https://pub.dev/packages/context_watch_bloc)          | `.watch(context)`<br/>`.watchOnly(context, () => ...)`<br/>`.watchEffect(context, () => ...)`<br/><br/>for `Bloc` and `Cubit` |
| [context_watch_mobx](https://github.com/s0nerik/context_plus/tree/main/packages/context_watch_mobx)       | [![context_watch_mobx](https://img.shields.io/pub/v/context_watch_mobx)](https://pub.dev/packages/context_watch_mobx)          | `.watch(context)`<br/>`.watchOnly(context, () => ...)`<br/>`.watchEffect(context, () => ...)`<br/><br/>for `Observable`       |
| [context_watch_getx](https://github.com/s0nerik/context_plus/tree/main/packages/context_watch_getx)       | [![context_watch_getx](https://img.shields.io/pub/v/context_watch_getx)](https://pub.dev/packages/context_watch_getx)          | `.watch(context)`<br/>`.watchOnly(context, () => ...)`<br/>`.watchEffect(context, () => ...)`<br/><br/>for `Rx`               |
| [context_watch_signals](https://github.com/s0nerik/context_plus/tree/main/packages/context_watch_signals) | [![context_watch_signals](https://img.shields.io/pub/v/context_watch_signals)](https://pub.dev/packages/context_watch_signals) | `.watch(context)`<br/>`.watchOnly(context, () => ...)`<br/>`.watchEffect(context, () => ...)`<br/><br/>for `Signal`           |

## Getting started

```shell
flutter pub add context_watch
```

Wrap your app in a `ContextWatch.root` widget.
```dart
ContextWatch.root(
  child: MaterialApp(...),
);
```

## Usage

```dart
final counterNotifier = ValueNotifier(0);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = counterNotifier.watch(context);
    return Text('Counter: $counter');
  }
}
```

That's it! No builders, no custom base classes.

Just call `watch()` on your observable value and you've got a reactive widget. `watch()`'ing a `ValueListenable`,
`ValueStream` or `SynchronousFuture` will also give you the current value synchronously, right away.

It doesn't matter where you call `watch()` from or how many times you call it. While in a build phase, it will
always register the `context` as a listener to the observable value. Whenever the observable notifies of a change,
the `context` will be marked as needing a rebuild.

## Additional information

### Is conditional watching supported?

Totally.

You can add or remove `watch()` calls from the build method as much as you want. The subscriptions are guaranteed to be canceled for all `watch()` calls that disappeared from the build method as a result of processing the `watch()`'ed observable value change notification. No extra rebuilds will be triggered.

Worst case scenario is you'll have exactly one additional rebuild upon observable notification if the widget was rebuilt due to anything else than `watch()`'ed observable notification and ALL `watch()` calls disappeared during that rebuild.

### Performance

Here's some benchmark results I got on my test device (Xiaomi Mi 9T Pro, Android 11):
```
Summary                                                         Ratio      Total subscriptions     Subscriptions description           Frame times                               
Stream.watch(context) vs StreamBuilder                          1.04x      2 total subs            1 tiles * 2 observables             123.48μs/frame vs 119.18μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.01x      2 total subs            1 tiles * 2 observables             118.25μs/frame vs 117.57μs/frame          
Stream.watch(context) vs StreamBuilder                          0.99x      20 total subs           10 tiles * 2 observables            117.11μs/frame vs 118.29μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.99x      20 total subs           10 tiles * 2 observables            125.07μs/frame vs 126.20μs/frame          
Stream.watch(context) vs StreamBuilder                          0.97x      200 total subs          100 tiles * 2 observables           124.08μs/frame vs 128.21μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.02x      200 total subs          100 tiles * 2 observables           126.66μs/frame vs 124.19μs/frame          
Stream.watch(context) vs StreamBuilder                          1.03x      400 total subs          200 tiles * 2 observables           136.98μs/frame vs 132.95μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.03x      400 total subs          200 tiles * 2 observables           133.89μs/frame vs 129.59μs/frame          
Stream.watch(context) vs StreamBuilder                          1.00x      1000 total subs         500 tiles * 2 observables           156.49μs/frame vs 156.61μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.03x      1000 total subs         500 tiles * 2 observables           160.20μs/frame vs 155.95μs/frame          
Stream.watch(context) vs StreamBuilder                          1.03x      1500 total subs         750 tiles * 2 observables           202.03μs/frame vs 195.29μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.07x      1500 total subs         750 tiles * 2 observables           177.80μs/frame vs 166.52μs/frame          
Stream.watch(context) vs StreamBuilder                          1.22x      2000 total subs         1000 tiles * 2 observables          261.17μs/frame vs 214.00μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.29x      2000 total subs         1000 tiles * 2 observables          240.30μs/frame vs 186.12μs/frame          
Stream.watch(context) vs StreamBuilder                          1.25x      10000 total subs        5000 tiles * 2 observables          50980.63μs/frame vs 40919.80μs/frame      
ValueListenable.watch(context) vs ValueListenableBuilder        1.03x      10000 total subs        5000 tiles * 2 observables          24822.21μs/frame vs 24126.57μs/frame      
Stream.watch(context) vs StreamBuilder                          1.04x      20000 total subs        10000 tiles * 2 observables         167661.58μs/frame vs 161882.15μs/frame    
ValueListenable.watch(context) vs ValueListenableBuilder        1.14x      20000 total subs        10000 tiles * 2 observables         99922.14μs/frame vs 87301.35μs/frame      
Stream.watch(context) vs StreamBuilder                          0.99x      40000 total subs        20000 tiles * 2 observables         293532.14μs/frame vs 295784.43μs/frame    
ValueListenable.watch(context) vs ValueListenableBuilder        1.28x      40000 total subs        20000 tiles * 2 observables         222806.22μs/frame vs 173726.25μs/frame    
Stream.watch(context) vs StreamBuilder                          1.02x      1 total subs            1 single stream subscriptions       123.83μs/frame vs 121.77μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.95x      1 total subs            1 single stream subscriptions       119.95μs/frame vs 126.18μs/frame          
Stream.watch(context) vs StreamBuilder                          0.96x      10 total subs           10 single stream subscriptions      120.39μs/frame vs 124.77μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.01x      10 total subs           10 single stream subscriptions      125.36μs/frame vs 124.10μs/frame          
Stream.watch(context) vs StreamBuilder                          0.99x      100 total subs          100 single stream subscriptions     122.81μs/frame vs 124.03μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.00x      100 total subs          100 single stream subscriptions     125.93μs/frame vs 126.14μs/frame          
Stream.watch(context) vs StreamBuilder                          1.00x      200 total subs          200 single stream subscriptions     122.83μs/frame vs 123.00μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.00x      200 total subs          200 single stream subscriptions     125.96μs/frame vs 126.03μs/frame          
Stream.watch(context) vs StreamBuilder                          1.02x      500 total subs          500 single stream subscriptions     129.61μs/frame vs 127.05μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.04x      500 total subs          500 single stream subscriptions     128.49μs/frame vs 123.32μs/frame          
Stream.watch(context) vs StreamBuilder                          1.02x      750 total subs          750 single stream subscriptions     132.97μs/frame vs 130.03μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.99x      750 total subs          750 single stream subscriptions     127.21μs/frame vs 127.99μs/frame          
Stream.watch(context) vs StreamBuilder                          1.03x      1000 total subs         1000 single stream subscriptions    139.48μs/frame vs 134.83μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.05x      1000 total subs         1000 single stream subscriptions    133.62μs/frame vs 127.10μs/frame
```

`example` contains both a [live benchmark](example/lib/benchmarks/context_watch/benchmark_screen.dart) and an [automated one](example/benchmarks/benchmark_context_watch.dart), so feel free to run them and compare the results on your device.
Don't forget to run them in `--profile` mode.

![benchmark.gif](https://github.com/s0nerik/context_watch/raw/main/doc/benchmark.gif)
