# context_ref

![context_ref.png](https://github.com/s0nerik/context_plus/raw/main/doc/context_ref.png)

[![context_ref](https://img.shields.io/pub/v/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/likes/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/points/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/dm/context_ref)](https://pub.dev/packages/context_ref)

A more convenient `InheritedWidget` alternative.

See [context_plus](https://pub.dev/packages/context_plus) for the ultimate convenience.

## Features

- `Ref<T>` - a reference to a value of type `T` bound to a `context` or multiple `context`s.
  - `.bind(context, () => Value())` - create and bind value to a `context`. Automatically `dispose()` the value upon `context` disposal.
  - `.bindLazy(context, () => Value())` - same as `.bind()`, but the value is created only when it's first accessed.
  - `.bindValue(context, value)` - bind an already created value to a `context`. The value is not disposed automatically.
  - `.of(context)` - get the value bound to the `context` or its nearest ancestor.

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

Initialize and propagate a value down the widget tree:

```dart
final _state = Ref<_State>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    // No need to specify the `dispose` callback by hand if the _State is
    // disposable via the `dispose` method.
    // 
    // The `_State` will be created right await and disposed when the widget
    // is removed from the widget tree.
    //
    // Use `bindLazy` if you want to create the value only when it's first accessed.
    _state.bind(context, () => _State());
    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    final state = _state.of(context);
    ...
  }
}
```

Provide an already-initialized value down the tree:

```dart
final _params = Ref<Params>();

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.params,
  });
  
  final Params params;

  @override
  Widget build(BuildContext context) {
    // Whenever the `params` value change, the `_Child` widget will get rebuilt.
    // Values provided via `bindValue` are not disposed automatically.
    _params.bindValue(context, params);
    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    final params = _params.of(context);
    ...
  }
}
```

For more examples, see the [example](https://github.com/s0nerik/context_plus/raw/main/example).
