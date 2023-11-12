# context_watch

[![context_watch](https://img.shields.io/pub/v/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/likes/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/points/context_watch)](https://pub.dev/packages/context_watch)
[![context_watch](https://img.shields.io/pub/popularity/context_watch)](https://pub.dev/packages/context_watch)

Listen to `Listenable` (`ValueNotifier`/`AnimationController`/`ScrollController`/`TabController` etc.) or `Stream`/`ValueStream` changes using a simple `observable.watch(context)`. No strings attached.

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
  const Example({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final counter = counterNotifier.watch(context);
    return Text('Counter: $counter');
  }
}
```

That's it! No builders, no custom base classes.

Just call `watch()` on your observable value and you've got a reactive widget. `watch()`'ing a `ValueListenable` or a
`ValueStream` will also give you the current value as a result.

It doesn't matter where you call `watch()` from or how many times you call it. While in a build phase, it will
always register the `context` as a listener to the observable value. Whenever the observable notifies of a change,
the `context` will be marked as needing a rebuild.

## Additional information

### Performance

Sounds too good to be true? It's not! But it comes at a slight performance cost. My tests show ~2-10% slowdown compared
to the equivalent `ValueListenableBuilder`. Still, it's fast enough for most use cases. Also, as the benchmark shows,
the same performance cost applies to other observability solutions like `Riverpod` or `MobX`, so it shouldn't be a
problem.

### `context.unwatch()`

Unfortunately, `InheritedWidget`s in Flutter never unsubscribe their dependents. `context_watch` does everything it can
to compensate for that, so that if widget goes from 2 `watch()`'es to only 1 - the second `watch()` will be
discarded, as expected. But still, there exists a single case where it's not possible to automagically compensate for a
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

To avoid this, you can manually call `context.unwatch()` at the beginning of the `build` method:
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
This way, all previous `watch()`'es will be discarded each `build` and only the new ones will be registered. This comes
at a cost, though - my benchmarks show that it's ~50% slower than the default behavior. So, if you're not experiencing
any issues with the default behavior - don't use `context.unwatch()`.
