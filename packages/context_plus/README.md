[![context_plus.webp](https://github.com/s0nerik/context_plus/raw/main/doc/context_plus_anim.webp)](https://context-plus.sonerik.dev)

> Visit [context-plus.sonerik.dev](https://context-plus.sonerik.dev) for more information and interactive examples.

# context_plus

[![context_plus](https://img.shields.io/pub/v/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/likes/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/points/context_plus)](https://pub.dev/packages/context_plus)
[![context_plus](https://img.shields.io/pub/dm/context_plus)](https://pub.dev/packages/context_plus)

This package combines [context_ref](https://pub.dev/packages/context_ref) and [context_watch](https://pub.dev/packages/context_watch) into a single, more convenient package.

It adds `.watch()`, `.watchOnly()`, `.watchEffect()` extension methods on the `Ref`s to supported observable types.

## Example

```
// Create a reference to any object
final _stream = Ref<Stream>();

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Bind the stream to this context and observe its state
    final streamSnapshot = context.use(
      () => Stream.periodic(const Duration(seconds: 1)),
      // Optionally, provide a `ref` parameter to bind the stream to it
      ref: _stream,
    ).watch(context);

    // ... or bind the stream lazily, so that it is initialized only upon first access via the `Ref`
    _stream.bindLazy(context, () => Stream.periodic(const Duration(seconds: 1)));

    // ... or bind the pre-existing stream to the `Ref` to expose it to the children
    _stream.bindValue(context, existingStream);

    return const _Child();
  }
}

class _Child extends StatelessWidget {
  const _Child();

  @override
  Widget build(BuildContext context) {
    // Observe the current state of a provided stream easily
    final streamSnapshot = _stream.watch(context);

    // The same works for most observable types:
    // - Stream, ValueStream, etc.
    // - Future, SynchronousFuture, FutureOr, etc.
    // - Listenable, ValueListenable and their descendants
    // - 3rd party observable types, such as:
    //   - `Bloc`, `Cubit` from flutter_bloc
    //   - `Signal` from signals
    //   - `Observable` from mobx
    //   - `Rx` from getx

    ...
  }
}
```

## Table of Contents

1. [Installation](#installation)
1. [Features](#features)
1. [Supported observable types for `.watch()`](#supported-observable-types)
1. [3rd party supported observable types for `.watch()` via separate packages](#3rd-party-supported-observable-types)
1. [API](#api)

<a name="installation"></a>
## Installation

1. Add `context_plus` to your `pubspec.yaml`:
   ```bash
   flutter pub add context_plus
   ```
1. Wrap your app in `ContextPlus.root`:
    ```dart
    ContextPlus.root(
      child: MaterialApp(...),
    );
    ```
1. (Optional, but recommended) Wrap default error handlers with `ContextPlus.errorWidgetBuilder()` and `ContextPlus.onError()` to get better hot reload related error messages:
    ```dart
    void main() {
      ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
      FlutterError.onError = ContextPlus.onError(FlutterError.onError);
    }
    ```
1. (Optional, but recommended) Add `context_plus_lint` to your `pubspec.yaml`
    ```bash
    flutter pub add --dev context_plus_lint
    flutter pub add --dev custom_lint
    ```
    Update the `analysis_options.yaml` to include
    ```yaml
    analyzer:
      plugins:
        - custom_lint
    ```
1. (Optional) Remove `context_ref` and `context_watch` from your `pubspec.yaml` if you have them.

<a name="features"></a>
## Features

- `context.use(() => ...)`
    - Bind an object to the scope of this `BuildContext`, so that it is:
      - initialized just once per `BuildContext` lifetime (unless the `key` or `ref` parameter value changes)
      - automatically disposed together with `BuildContext`
      - accessible by all children via the provided `Ref` (if `ref:` parameter is specified)
- [`Ref<T>`](#api-ref) - a reference to a value of type `T` bound to a `context` or multiple `context`s.
    - [`.bind(context, () => ...)`](#api-ref-bind) - create and bind value to a `context`. Automatically `dispose()` the value upon `context` disposal.
    - [`.bindLazy(context, () => ...)`](#api-ref-bind-lazy) - same as `.bind()`, but the value is created only when it's first accessed.
    - [`.bindValue(context, ...)`](#api-ref-bind-value) - bind an already created value to a `context`. The value is not disposed automatically.
    - [`.of(context)`](#api-ref-of) - get the value bound to the `context` or its nearest ancestor.
- `Listenable`/`ValueListenable`/`Future`/`Stream` (and [more](#supported-observable-types)) or `Ref` of any of these types:
    - [`.watch(context)`](#api-watch) - rebuild the `context` whenever the observable notifies of a change. Returns the current value or `AsyncSnapshot` for corresponding types.
    - [`.watchOnly(context, (...) => ...)`](#api-watch-only) - rebuild the `context` whenever the observable notifies of a change, but only if selected value has changed.
    - [`.watchEffect(context, (...) => ...)`](#api-watch-effect) - execute the provided callback whenever the observable notifies of a change *without* rebuilding the `context`.
    - Multi-value observing of up to 4 values:

      ```dart
      // Observe multiple values from observable objects
      final (value, futureSnap, streamSnap) =
          (valueListenable, future, stream).watch(context);
                                           // or
                                           .watchOnly(context, (...) => ...);
                                           // or
                                           .watchEffect(context, (...) => ...);
      // Observe multiple values from Refs to observable objects
      final (streamSnap, value, futureSnap) =
          (streamRef, valueListenableRef, futureRef).watch(context);
                                                    // or
                                                    .watchOnly(context, (...) => ...);
                                                    // or
                                                    .watchEffect(context, (...) => ...);
      ```
      
      All three methods are available for all combinations of observables and observable Refs.
      
      ** *Note*: IDE suggestions for `watch*()` methods on records work only with Dart 3.6 and newer (see [dart-lang/sdk#56572](https://github.com/dart-lang/sdk/issues/56572)).

<a name="supported-observable-types"></a>
### Supported observable types for `Observable.watch()` and `Ref<Observable>.watch()`:

- `Listenable`, `ValueListenable`:
  - `ChangeNotifier`
  - `ValueNotifier`
  - `AnimationController`
  - `ScrollController`
  - `TabController`
  - `TextEditingController`
  - `FocusNode`
  - `PageController`
  - `RefreshController`
  - ... and any other `Listenable` derivatives
- `Future`, `SynchronousFuture`
- `Stream`
- `ValueStream` (from [rxdart](https://pub.dev/packages/rxdart))
- `AsyncListenable` (from [async_listenable](https://pub.dev/packages/async_listenable))

<a name="3rd-party-supported-observable-types"></a>
### 3rd party supported observable types for `Observable.watch()` via separate packages:
- `Bloc`, `Cubit` (from [bloc](https://pub.dev/packages/bloc), using [context_watch_bloc](https://pub.dev/packages/context_watch_bloc))
- `Observable` (from [mobx](https://pub.dev/packages/mobx), using [context_watch_mobx](https://pub.dev/packages/context_watch_mobx))
- `Rx` (from [get](https://pub.dev/packages/get), using [context_watch_getx](https://pub.dev/packages/context_watch_getx))
- `Signal` (from [signals](https://pub.dev/packages/signals), using [context_watch_signals](https://pub.dev/packages/context_watch_signals))

<a name="api"></a>
## API

<a name="api-use"></a>
### `context.use(() => ...)`

```dart
T BuildContext.use<T>(
  T Function() create, {
  void Function(T value)? dispose,
  Ref<T>? ref,
  Object? key,
});
```

- Creates a value `T` by calling the `create` callback immeditely if `T` wasn't created yet, otherwise just returns the existing `T` value.
- Keeps `T` alive for the lifespan of a given `BuildContext`.
- Automatically disposes `T` when `BuildContext` is disposed by calling the `dispose` callback (if provided) or `T.dispose()` method (if callback is not provided).
- Binds `T` to the `ref`, if provided.
- Similarly to widgets, `key` parameter allows for updating the value initializer.

<a name="api-ref"></a>
### `Ref`

`Ref<T>` is a reference to a value of type `T` provided by a parent `BuildContext`.

It behaves similarly to `InheritedWidget` with a single value property and provides a conventional `.of(context)` method to access the value in descendant widgets.

`Ref<AnyObservableType>` also provides
`.watch()` and `.watchOnly()` methods to observe the value conveniently.

`Ref` can be bound only to a single value per `BuildContext`. Child contexts can override their parents' `Ref` bindings.

Common places to declare `Ref` instances are:
- As a global file-private variable.
  ```dart
  final _value = Ref<ValueType>();
  ```
  - Useful for sharing values across multiple closely-related widgets (e.g. per-screen values).
- As a global public variable
  ```dart
  final appTheme = Ref<AppTheme>();
  ```
  - Useful for sharing values across the entire app.
- As a static field in a widget class
  ```dart
  class SomeWidget extends StatelessWidget {
    static final _value = Ref<ValueType>();
    ...
  }
  ```
  - Useful for adding a state to a stateless widget without converting it to a stateful widget. The same applies to all previous examples, but this one is more localized, which improves readability for such use-case.

<a name="api-ref-bind"></a>
### `Ref.bind()`

```dart
T Ref<T>.bind(
  BuildContext context,
  T Function() create, {
  void Function(T value)? dispose,
  Object? key,
})
```

- Binds a [`Ref<T>`](#api-ref) to the value initializer (`create`) for all descendants of `context` and `context` itself.
- Value initialization happens immediately. Use `.bindLazy()` if you need it lazy.
- Value is `.dispose()`'d automatically when the widget is disposed. Provide a `dispose` callback to customize the disposal if needed.
- Similarly to widgets, `key` parameter allows for updating the value initializer when needed.

<a name="api-ref-bind-lazy"></a>
### `Ref.bindLazy()`

```dart
void Ref<T>.bindLazy(
  BuildContext context,
  T Function() create, {
  void Function(T value)? dispose,
  Object? key,
})
```

Same as [`Ref.bind()`](#api-ref-bind), but the value is created only when it's first accessed via `Ref.of(context)` or `Ref.watch()`/`Ref.watchOnly()`, thus not returned immediately.

<a name="api-ref-bind-value"></a>
### `Ref.bindValue()`

```dart
T Ref<T>.bindValue(
  BuildContext context,
  T value,
)
```

- Binds a [`Ref<T>`](#api-ref) to the `value` for all descendants of `context` and `context` itself.
- Whenever the value changes, the dependent widgets will be automatically rebuilt.
- Values provided this way are *not* disposed automatically.

<a name="api-ref-of"></a>
### `Ref.of(context)`

```dart
T Ref<T>.of(BuildContext context)
```

- Fetches the value of type `T` provided by the [`Ref<T>.bind()`](#api-ref-bind)/[`Ref<T>.bindLazy()`](#api-ref-bind-lazy)/[`Ref<T>.bindValue()`](#api-ref-bind-value) in the nearest ancestor of `context`.
- Rebuilds the widget whenever the value provided with [`Ref<T>.bindValue()`](#api-ref-bind-value) changes.
- Throws an exception if the value is not provided in the ancestor tree.

<a name="api-watch"></a>
### `Ref<Observable>.watch()` and `Observable.watch()`

```dart
TListenable TListenable.watch(BuildContext context)
TListenable Ref<TListenable>.watch(BuildContext context)
```
- Rebuilds the widget whenever the `Listenable` notifies about changes.

```dart
T ValueListenable<T>.watch(BuildContext context)
T Ref<ValueListenable<T>>.watch(BuildContext context)
```
- Rebuilds the widget whenever the `ValueListenable` notifies about changes.
- Returns the current value of the `ValueListenable`.

```dart
AsyncSnapshot<T> Future<T>.watch(BuildContext context)
AsyncSnapshot<T> Ref<Future<T>>.watch(BuildContext context)

AsyncSnapshot<T> Stream<T>.watch(BuildContext context)
AsyncSnapshot<T> Ref<Stream<T>>.watch(BuildContext context)

AsyncSnapshot<T> AsyncListenable<T>.watch(BuildContext context)
AsyncSnapshot<T> Ref<AsyncListenable<T>>.watch(BuildContext context)
```
- Rebuilds the widget whenever the value notifies about changes.
- Returns and `AsyncSnapshot` describing the current state of the value.
- `.watch()`'ing a `SynchronousFuture` or `ValueStream` (from [rxdart](https://pub.dev/packages/rxdart)) will return a `AsyncSnapshot` with properly initialized `data`/`error` field, if initial value/error exists.
- [`AsyncListenable`](https://pub.dev/packages/async_listenable) can be used for dynamic swapping of the listened-to async value without losing the current state. See the [live search example](https://context-plus.sonerik.dev/country_search_example) for a practical use-case.

Many popular observable types from 3rd party packages have their own `.watch()` methods provided by separate packages. See the [3rd party supported observable types](#3rd-party-supported-observable-types) for more information.

<a name="api-watch-only"></a>
### `Ref<Observable>.watchOnly()` and `Observable.watchOnly()`

```dart
R TListenable.watchOnly<R>(
  BuildContext context,
  R Function(TListenable listenable) selector,
)

R ValueListenable<T>.watchOnly<R>(
  BuildContext context,
  R Function(T value) selector,
)
```
- Invokes `selector` whenever the `Listenable` notifies about changes.
- Rebuilds the widget whenever the `selector` returns a different value.
- Returns the selected value.

```dart
R Future<T>.watchOnly<R>(
  BuildContext context,
  R Function(AsyncSnapshot<T> value) selector,
)

R Stream<T>.watchOnly<R>(
  BuildContext context,
  R Function(AsyncSnapshot<T> value) selector,
)
```
- Invokes `selector` whenever the async value notifies about changes.
- Rebuilds the widget whenever the `selector` returns a different value.
- Returns the selected value.

<a name="api-watch-effect"></a>
### `Ref<Observable>.watchEffect()` and `Observable.watchEffect()`

```dart
void TListenable.watchEffect(
  BuildContext context,
  void Function(TListenable listenable) effect, {
  Object? key,
  bool immediate = false,
  bool once = false,
})

void ValueListenable<T>.watchEffect(
  BuildContext context,
  void Function(T value) effect, {
  Object? key,
  bool immediate = false,
  bool once = false,
})

void Future<T>.watchEffect(
  BuildContext context,
  void Function(AsyncSnapshot<T> snapshot) effect, {
  Object? key,
  bool immediate = false,
  bool once = false,
})

void Stream<T>.watchEffect(
  BuildContext context,
  void Function(AsyncSnapshot<T> snapshot) effect, {
  Object? key,
  bool immediate = false,
  bool once = false,
})
```
- Invokes `effect` on each value change notification.
- Does *not* rebuild the widget on changes.
- `key` parameter allows for uniquely identifying the effect, which is needed
  for conditional effects, `immeadiate` and `once` effects.
- `immediate` parameter allows for invoking the effect immediately after binding.
  Requires a unique `key`. Can be combined with `once`.
- `once` parameter allows for invoking the effect only once. Requires a unique `key`.
  Can be combined with `immediate`.
- Can be used conditionally, in which case the [`.unwatchEffect()`](#api-unwatch-effect) usage is recommended as well.

<a name="api-unwatch-effect"></a>
#### `Ref<Observable>.unwatchEffect()` and `Observable.unwatchEffect()`

```dart
void Listenable.unwatchEffect(
  BuildContext context, {
  required Object key,
})

void Future.unwatchEffect(
  BuildContext context, {
  required Object key,
})

void Stream.unwatchEffect(
  BuildContext context,
  required Object key,
)
```
- Unregisters the effect with the specified `key`.
- Useful for conditional effects where removing the effect ASAP is needed:
  ```dart
  if (condition) {
    observable.watchEffect(context, key: 'effect', ...);
  } else {
    observable.unwatchEffect(context, key: 'effect');
  }
  ```