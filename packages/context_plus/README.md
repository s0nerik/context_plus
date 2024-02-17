This package combines [context_ref](https://pub.dev/packages/context_ref) and [context_watch](https://pub.dev/packages/context_watch) into a single, more convenient package.

## Features

- Makes observing a value from `Ref` more convenient.
- Reduces the likeliness of extra rebuilds due to conditional `watch()` calls. Calling `Ref.of(context)`, `Ref.watch(context)`, `Ref.watchOnly(context, ...)` via this package will invoke `context.unwatch()` under the hood.

| Types                                           | context_plus                       | context_watch + context_ref (separately)                                          |
|-------------------------------------------------|------------------------------------|-----------------------------------------------------------------------------------|
| `Ref<T>`                                        | `ref.of(context)`                  | <code>context.unwatch();<br/>ref.of(context);</code>                              |
| `Ref<Listenable>`, `Ref<Stream>`, `Ref<Future>` | `ref.watch(context)`               | <code>context.unwatch();<br/>ref.of(context).watch(context);</code>               |
| `Ref<Listenable>`, `Ref<Stream>`, `Ref<Future>` | `ref.watchOnly(context, ...)`      | <code>context.unwatch();<br/>ref.of(context).watchOnly(context, ...);</code>      |
| `Ref<ValueListenable>`                          | `ref.watchValue(context)`          | <code>context.unwatch();<br/>ref.of(context).watchValue(context);</code>          |
| `Ref<ValueListenable>`                          | `ref.watchValueOnly(context, ...)` | <code>context.unwatch();<br/>ref.of(context).watchValueOnly(context, ...);</code> |

## Getting started

```shell
flutter pub add context_watch
```

Wrap your app in `ContextPlus.root`. Remove `ContextWatch.root` and `ContextRef.root` if you have them.
```dart
ContextPlus.root(
  child: MaterialApp(...),
);
```

## Usage

See [context_ref](https://pub.dev/packages/context_ref) and [context_watch](https://pub.dev/packages/context_watch) for more information.
