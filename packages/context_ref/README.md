# context_ref

![context_ref.png](https://github.com/s0nerik/context_plus/raw/main/doc/context_ref.png)

[![context_ref](https://img.shields.io/pub/v/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/likes/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/points/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/popularity/context_ref)](https://pub.dev/packages/context_ref)

A more convenient `InheritedWidget` alternative.

See [context_plus](https://pub.dev/packages/context_plus) for the ultimate convenience.

## Getting started

```shell
flutter pub add context_ref
```

Wrap your app in a `ContextRef.root` widget.
```dart
ContextRef.root(
  child: MaterialApp(...),
);
```

(Optional) Wrap default error handlers with `ContextRef.errorWidgetBuilder()` and `ContextRef.onError()` to get better hot reload related error messages.
```dart
void main() {
  ErrorWidget.builder = ContextRef.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextRef.onError(FlutterError.onError);
}
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```
