See https://pub.dev/packages/context_watch

## Usage

Remove `signals_flutter` from your `pubspec.yaml`. `context_watch_signals` re-exports everything from `signals_flutter` except the original `watch()` and `unwatch()` extensions, so that you don't have name resolution conflicts.

Add `SignalContextWatcher.instance` to `additionalWatchers` of `ContextPlus.root`:
```dart
ContextPlus.root(
  additionalWatchers: [
    SignalContextWatcher.instance,
  ],
  child: ...,
);
```

Observe `Signal`s with `Signal.watch(context)` or `Signal.watchOnly(context, () => ...)`:
```dart
final _counter = signal(0);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = _counter.watch(context);
    final counterSquared = _counter.watchOnly(context, (counter) => counter * counter);
    return Text('Counter: $counter, Counter²: $counterSquared');
  }
}
```
