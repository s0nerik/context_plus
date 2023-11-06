Listen to `Listenable` (`ValueNotifier`/`AnimationController`/`ScrollController`/`TabController` etc.) or `Stream`/`ValueStream` changes using a simple `observable.watch(context)`. No strings attached.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

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
    final counter = counter.watch(context);
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

Sounds too good to be true? It's not! But it comes at a slight performance cost. My tests show ~2-10% slowdown compared
to the equivalent `ValueListenableBuilder`. Still, it's fast enough for most use cases. Also, as the benchmark shows,
the same performance cost applies to other observability solutions like `Riverpod` or `MobX`, so it shouldn't be a
problem.
