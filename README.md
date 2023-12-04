# context_watch

![context_watch.png](doc/context_watch.png)

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

### Performance

Sounds too good to be true? It's not! But it comes at a slight performance cost.

Here's some benchmark results I got on my device:
```
Summary                                               Total subscriptions     Subscriptions description           Frame times                                   Result
Stream.watch(context) vs StreamBuilder: 0.99x         2 total subs            1 tiles * 2 observables             120.32μs/frame vs 121.99μs/frame              Stream.watch(context) is faster than StreamBuilder
Stream.watch(context) vs StreamBuilder: 0.97x         20 total subs           10 tiles * 2 observables            123.49μs/frame vs 127.68μs/frame              Stream.watch(context) is faster than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.00x         200 total subs          100 tiles * 2 observables           129.56μs/frame vs 129.43μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.01x         400 total subs          200 tiles * 2 observables           138.93μs/frame vs 137.55μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.06x         1000 total subs         500 tiles * 2 observables           174.76μs/frame vs 165.05μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.05x         1500 total subs         750 tiles * 2 observables           211.49μs/frame vs 201.05μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.17x         2000 total subs         1000 tiles * 2 observables          272.60μs/frame vs 232.19μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.29x         10000 total subs        5000 tiles * 2 observables          50861.28μs/frame vs 39294.43μs/frame          Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.28x         20000 total subs        10000 tiles * 2 observables         177639.00μs/frame vs 138427.80μs/frame        Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.25x         40000 total subs        20000 tiles * 2 observables         382832.00μs/frame vs 305834.57μs/frame        Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 0.99x         1 total subs            1 single stream subscriptions       123.57μs/frame vs 124.51μs/frame              Stream.watch(context) is faster than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.00x         10 total subs           10 single stream subscriptions      126.01μs/frame vs 126.49μs/frame              Stream.watch(context) is faster than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.03x         100 total subs          100 single stream subscriptions     130.68μs/frame vs 126.68μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.06x         200 total subs          200 single stream subscriptions     138.02μs/frame vs 130.04μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.24x         500 total subs          500 single stream subscriptions     173.43μs/frame vs 140.15μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 1.45x         750 total subs          750 single stream subscriptions     220.93μs/frame vs 151.88μs/frame              Stream.watch(context) is slower than StreamBuilder
Stream.watch(context) vs StreamBuilder: 2.09x         1000 total subs         1000 single stream subscriptions    353.87μs/frame vs 168.92μs/frame              Stream.watch(context) is slower than StreamBuilder
```

`example` contains both a [live benchmark](example/lib/benchmark_screen.dart) and an [automated one](example/test/stream_watch_benchmark.dart), so feel free to run them and compare the results on your device.
Don't forget to run them in `--profile` mode.

![benchmark.gid](doc/benchmark.gif)

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
