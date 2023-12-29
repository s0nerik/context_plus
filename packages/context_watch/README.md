# context_watch

![context_watch.png](https://github.com/s0nerik/context_watch/raw/main/doc/context_watch.png)

[![context_watch](https://img.shields.io/pub/v/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/likes/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/points/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/popularity/context_watch)](https://pub.dev/packages/context_watch)

Listen to `Listenable` (`ValueNotifier`/`AnimationController`/`ScrollController`/`TabController` etc.) or `Stream`/`ValueStream` changes using a simple `observable.watch(context)`. No strings attached.

**Note:** Flutter 3.17.0-1.0.pre.38 or higher is required.

## Getting started

```shell
flutter pub add context_watch
```

Wrap your app in a `ContextWatchRoot`
```dart
ContextWatchRoot(
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

### Supported observable types

- `Listenable` (`ValueNotifier`/`AnimationController`/`ScrollController`/`TabController` etc.)
- `Stream`/`ValueStream`
- `Future`/`SynchronousFuture`

## Additional information

### `context.unwatch()`

If you have conditional `watch()`'es in your `build` method, you might want to add an unconditional `context.unwatch()`
call to avoid potential unnecessary rebuilds. This doesn't incur any performance penalty and can be called multiple
times, so feel free to call it whenever you need.

#### Why is it needed?

Unfortunately, `InheritedWidget`s in Flutter never unsubscribe their dependents. `context_watch` does everything it can
to compensate for that, so that if widget goes from 2 `watch()`'es to only 1 - the second `watch()` will be
discarded, as expected. But still, there exists a case where it's not possible to automagically compensate for the
Flutter's limitation. If a widget goes from 1 (or more) `watch()` to 0, the `context` will still be registered as a
listener to all of them, as it's impossible to know that `watch()`'es are now completely gone from the `build` method.

So, given this example:
```dart
Widget build(BuildContext context) {
  if (condition1) {
    counter1.watch(context);
  }
  if (condition2) {
    counter2.watch(context);
  }
  ...
}
```
if widget transitions from `condition1 == true && condition2 == true` to `condition1 == false && condition2 == true` - it
will be rebuilt only when `counter2` changes. But if widget transitions from `condition1 == true && condition2 == true` to
`condition1 == false && condition2 == false` - it will be rebuilt when either `counter1` or `counter2` changes.

To avoid this, you can unconditionally call `context.unwatch()` inside the `build` method:
```dart
Widget build(BuildContext context) {
  context.unwatch();
  if (condition1) {
    counter1.watch(context);
  }
  if (condition2) {
    counter2.watch(context);
  }
  ...
}
```
This will ensure that all conditional `watch()`'es are discarded each `build`. Calling `context.unwatch()` doesn't
incur any performance penalty, so feel free to call it unconditionally in all your `build` methods whenever you need.

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

`example` contains both a [live benchmark](example/lib/benchmark_screen.dart) and an [automated one](example/test/stream_watch_benchmark.dart), so feel free to run them and compare the results on your device.
Don't forget to run them in `--profile` mode.

![benchmark.gif](https://github.com/s0nerik/context_watch/raw/main/doc/benchmark.gif)
