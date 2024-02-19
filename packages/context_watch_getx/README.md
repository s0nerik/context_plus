See https://pub.dev/packages/context_watch

## Usage

Add `GetxContextWatcher.instance` to `additionalWatchers` of `ContextPlus.root`:
```dart
ContextPlus.root(
  additionalWatchers: [
    GetxContextWatcher.instance,
  ],
  child: ...,
);
```

Observe GetX's `Rx` values with `Rx.watch(context)` or `Rx.watchOnly(context, () => ...)`, without wrapping anything with `Obx`:
```dart
final _counter = Rx(0);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = _counter.watch(context);
    return Text('Counter: $counter');
  }
}
```
