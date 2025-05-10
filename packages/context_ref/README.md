![context_ref.png](https://github.com/s0nerik/context_plus/raw/main/doc/context_ref.png)

> See [context_plus](https://pub.dev/packages/context_plus) for the ultimate convenience.
> 
> It combines [context_watch](https://pub.dev/packages/context_watch) with [context_ref](https://pub.dev/packages/context_ref) for effortless object propagation and observing.
> 
> 
> Visit [context-plus.sonerik.dev](https://context-plus.sonerik.dev) for more information and interactive examples.

# context_ref

[![context_ref](https://img.shields.io/pub/v/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/likes/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/points/context_ref)](https://pub.dev/packages/context_ref)
[![context_ref](https://img.shields.io/pub/dm/context_ref)](https://pub.dev/packages/context_ref)

A convenient way of providing objects scoped to a `BuildContext` and propagating them further down the tree.

## Example

```
// Create a reference to an object
final _stream = Ref<Stream>();

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Bind an object to the scope of this BuildContext, so that it is:
    // - initialized just once
    // - automatically disposed together with the context
    // - accessible by all children via the `Ref`
    final stream = _stream.bind(context, () => Stream.periodic(const Duration(seconds: 1)));
    
    // ... or bind it lazily, so that the object is initialized only upon first access via `Ref`
    _stream.bindLazy(context, () => Stream.periodic(const Duration(seconds: 1)));

    // ... or bind the pre-existing object to the `Ref` to expose it to the children
    _stream.bindValue(context, existingStream);

    // ... or just use the object within the scope of this BuildContext, without
    //     necessarily binding it to a `Ref`
    final stream = context.use(
      () => Stream.periodic(const Duration(seconds: 1)),
      // Optionally, provide a `ref` parameter to bind the object to it
      ref: _stream,
    );

    // ... use context.vsync whenever a TickerProvider is needed. 
    final animCtrl = context.use(
      () => AnimationController(vsync: context.vsync, duration: duration),
    );

    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    final stream = _stream.of(context);
    // ... or use context_plus to observe the state of a bound object easily
    final streamSnapshot = _stream.watch(context);
    ...
  }
}
```

## Installation

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

### Initialize and use some object within the scope of this `BuildContext`:

```dart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = context.use(() => Stream.periodic(const Duration(seconds: 1)));
    // Use StreamBuilder or context_watch to observe the current state of the stream
    ...
  }
}
```

<a name="use-parameter-combinations"></a>
Each object `use()`'d within a given `BuildContext` is assigned the following key: `(Type, Ref?, Key?)`. This key must be unique within the `build` method.

So,
```dart
final stream1 = context.use(() async* { yield 1; });
final stream2 = context.use(() async* { yield 'hello'; });
final future1 = context.use(() async => 'Hey');
final future2 = context.use(() async => 0.0);
final notifier1 = context.use(() => ValueNotifier(0));
final notifier2 = context.use(() => ValueNotifier('Hey'));
```

will just work, while

```dart
final notifier1 = context.use(() => ValueNotifier(1));
final notifier2 = context.use(() => ValueNotifier(2));
```

would ask you to provide a unique `key`, `ref` (or their combination) to one of the `use()` calls.

Use [context_plus_lint](https://pub.dev/packages/context_plus_lint) to learn about the need to specify a key for the `use()` call before even running the code.

### Initialize and propagate a value down the widget tree:

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

### Provide an already-initialized value down the tree:

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
