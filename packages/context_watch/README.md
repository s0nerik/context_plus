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

Sounds too good to be true? It's not! But it comes at a slight performance cost.

Here's some benchmark results I got on my test device (Xiaomi Mi 9T Pro, Android 11):
```
Summary                                                         Ratio      Total subscriptions     Subscriptions description           Frame times                               
Stream.watch(context) vs StreamBuilder                          0.99x      2 total subs            1 tiles * 2 observables             117.91μs/frame vs 118.62μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.00x      2 total subs            1 tiles * 2 observables             120.99μs/frame vs 121.02μs/frame          
Stream.watch(context) vs StreamBuilder                          0.99x      20 total subs           10 tiles * 2 observables            120.97μs/frame vs 121.91μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.97x      20 total subs           10 tiles * 2 observables            122.52μs/frame vs 125.97μs/frame          
Stream.watch(context) vs StreamBuilder                          0.98x      200 total subs          100 tiles * 2 observables           128.54μs/frame vs 130.87μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.98x      200 total subs          100 tiles * 2 observables           127.80μs/frame vs 129.75μs/frame          
Stream.watch(context) vs StreamBuilder                          1.00x      400 total subs          200 tiles * 2 observables           136.57μs/frame vs 137.02μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.99x      400 total subs          200 tiles * 2 observables           130.93μs/frame vs 132.28μs/frame          
Stream.watch(context) vs StreamBuilder                          1.08x      1000 total subs         500 tiles * 2 observables           178.92μs/frame vs 165.16μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.00x      1000 total subs         500 tiles * 2 observables           167.37μs/frame vs 166.70μs/frame          
Stream.watch(context) vs StreamBuilder                          1.12x      1500 total subs         750 tiles * 2 observables           214.92μs/frame vs 191.78μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.07x      1500 total subs         750 tiles * 2 observables           187.26μs/frame vs 174.73μs/frame          
Stream.watch(context) vs StreamBuilder                          1.08x      2000 total subs         1000 tiles * 2 observables          256.32μs/frame vs 236.80μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.15x      2000 total subs         1000 tiles * 2 observables          240.91μs/frame vs 209.55μs/frame          
Stream.watch(context) vs StreamBuilder                          1.35x      10000 total subs        5000 tiles * 2 observables          54083.97μs/frame vs 40094.12μs/frame      
ValueListenable.watch(context) vs ValueListenableBuilder        1.54x      10000 total subs        5000 tiles * 2 observables          32596.02μs/frame vs 21103.13μs/frame      
Stream.watch(context) vs StreamBuilder                          1.16x      20000 total subs        10000 tiles * 2 observables         164675.69μs/frame vs 142211.53μs/frame    
ValueListenable.watch(context) vs ValueListenableBuilder        0.91x      20000 total subs        10000 tiles * 2 observables         89202.52μs/frame vs 97572.36μs/frame      
Stream.watch(context) vs StreamBuilder                          0.87x      40000 total subs        20000 tiles * 2 observables         348985.33μs/frame vs 401505.20μs/frame    
ValueListenable.watch(context) vs ValueListenableBuilder        0.98x      40000 total subs        20000 tiles * 2 observables         212775.60μs/frame vs 216926.10μs/frame    
Stream.watch(context) vs StreamBuilder                          1.00x      1 total subs            1 single stream subscriptions       121.23μs/frame vs 121.17μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        0.99x      1 total subs            1 single stream subscriptions       123.37μs/frame vs 124.19μs/frame          
Stream.watch(context) vs StreamBuilder                          0.97x      10 total subs           10 single stream subscriptions      122.24μs/frame vs 125.46μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.01x      10 total subs           10 single stream subscriptions      124.00μs/frame vs 122.89μs/frame          
Stream.watch(context) vs StreamBuilder                          1.03x      100 total subs          100 single stream subscriptions     127.83μs/frame vs 123.70μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.03x      100 total subs          100 single stream subscriptions     126.83μs/frame vs 123.71μs/frame          
Stream.watch(context) vs StreamBuilder                          1.05x      200 total subs          200 single stream subscriptions     135.04μs/frame vs 128.62μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.04x      200 total subs          200 single stream subscriptions     132.33μs/frame vs 127.33μs/frame          
Stream.watch(context) vs StreamBuilder                          1.14x      500 total subs          500 single stream subscriptions     159.14μs/frame vs 139.30μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.14x      500 total subs          500 single stream subscriptions     146.54μs/frame vs 128.17μs/frame          
Stream.watch(context) vs StreamBuilder                          1.26x      750 total subs          750 single stream subscriptions     192.66μs/frame vs 153.39μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.24x      750 total subs          750 single stream subscriptions     164.67μs/frame vs 132.60μs/frame          
Stream.watch(context) vs StreamBuilder                          1.43x      1000 total subs         1000 single stream subscriptions    260.90μs/frame vs 182.70μs/frame          
ValueListenable.watch(context) vs ValueListenableBuilder        1.41x      1000 total subs         1000 single stream subscriptions    188.28μs/frame vs 133.33μs/frame 
```

`example` contains both a [live benchmark](example/lib/benchmark_screen.dart) and an [automated one](example/test/stream_watch_benchmark.dart), so feel free to run them and compare the results on your device.
Don't forget to run them in `--profile` mode.

![benchmark.gif](https://github.com/s0nerik/context_watch/raw/main/doc/benchmark.gif)
