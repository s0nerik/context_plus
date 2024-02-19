See https://pub.dev/packages/context_watch

## Usage

Add `MobxContextWatcher.instance` to `additionalWatchers` of `ContextPlus.root`:
```dart
ContextPlus.root(
  additionalWatchers: [
    MobxContextWatcher.instance,
  ],
  child: ...,
);
```

Observe MobX `Observable` with `Observable.watch(context)` or `Observable.watchOnly(context, () => ...)`, without wrapping anything with `Observer` or subclassing the `ObserverStatelessWidget`:
```dart
final _counter = Observable(0);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = _counter.watch(context);
    return Text('Counter: $counter');
  }
}
```
