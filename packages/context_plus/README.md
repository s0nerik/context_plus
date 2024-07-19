# [<img src="https://github.com/s0nerik/context_plus/raw/main/example/web/icons/Icon-192.png" alt="icon.png" width="192"/>](https://sonerik.dev/context_plus/) <br/> context_plus

[![showcase](https://github.com/s0nerik/context_plus/raw/main/doc/context_plus_anim.webp)](https://sonerik.dev/context_plus/)

[![context_plus](https://img.shields.io/pub/v/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/likes/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/points/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/popularity/context_plus)](https://pub.dev/packages/context_plus)

This package combines [context_ref](https://pub.dev/packages/context_ref) and [context_watch](https://pub.dev/packages/context_watch) into a single, more convenient package.

## Features

- Makes observing a value from `Ref` more convenient.
- Reduces the likeliness of extra rebuilds due to conditional `watch()` calls. Calling `Ref.of(context)`, `Ref.watch(context)`, `Ref.watchOnly(context, ...)` via this package will invoke [`context.unwatch()`](https://github.com/s0nerik/context_plus/tree/master/packages/context_watch#contextunwatch) under the hood.

| Types                                           | context_plus                  | context_watch + context_ref (separately)                      |
|-------------------------------------------------|-------------------------------|---------------------------------------------------------------|
| `Ref<T>`                                        | `ref.of(context)`             | `context.unwatch(); ref.of(context);`                         |
| `Ref<T>`                                        | `ref.bind(context, ...)`      | `context.unwatch(); ref.bind(context);`                       |
| `Ref<T>`                                        | `ref.bindLazy(context, ...)`  | `context.unwatch(); ref.bindLazy(context);`                   |
| `Ref<T>`                                        | `ref.bindValue(context, ...)` | `context.unwatch(); ref.bindValue(context);`                  |
| `Ref<Listenable>`, `Ref<Stream>`, `Ref<Future>` | `ref.watch(context)`          | `context.unwatch(); ref.of(context).watch(context);`          |
| `Ref<Listenable>`, `Ref<Stream>`, `Ref<Future>` | `ref.watchOnly(context, ...)` | `context.unwatch(); ref.of(context).watchOnly(context, ...);` |

## Getting started

Add `context_plus` to your `pubspec.yaml`:
```shell
flutter pub add context_plus
```

Remove `context_ref` and `context_watch` from your `pubspec.yaml` if you have them:
```shell
flutter pub remove context_ref
flutter pub remove context_watch
```

Wrap your app in `ContextPlus.root`. Remove `ContextWatch.root` and `ContextRef.root` if you have them.
```dart
ContextPlus.root(
  child: MaterialApp(...),
);
```

(Optional) Wrap default error handlers with `ContextPlus.errorWidgetBuilder()` and `ContextPlus.onError()` to get better hot reload related error messages. Replace `ContextRef.errorWidgetBuilder()` and `ContextRef.onError()` if you have them.
```dart
void main() {
  ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextPlus.onError(FlutterError.onError);
}
```

## Usage

See [context_ref](https://pub.dev/packages/context_ref) and [context_watch](https://pub.dev/packages/context_watch) for more information.
