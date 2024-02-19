See https://pub.dev/packages/context_watch

## Usage

Add `BlocContextWatcher.instance` to `additionalWatchers` of `ContextPlus.root`:
```dart
ContextPlus.root(
  additionalWatchers: [
    BlocContextWatcher.instance,
  ],
  child: ...,
);
```
