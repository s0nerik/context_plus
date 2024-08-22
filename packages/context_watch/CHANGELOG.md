## 5.0.0

> Note: This release does *not* contain any breaking API changes.
>
> This is a major release because the underlying implementation of
> `InheritedContextWatch` and `ContextWatcher` had changed significantly and
> the behavior of `watchOnly()` had been improved to reduce unnecessary rebuilds
> in one of the edge cases.

 - **FEAT**: watchEffect() for attaching side effects to the observed data.

## 4.0.0

> Note: This release has breaking changes.

 - **DOCS**: README.md update.
 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!
   
   All cases of conditional `.watch()`'ing are now handled automatically.

## 3.3.0

 - **FEAT**: [context_watch] Removes the rxdart dependency, ValueStreams are still supported! (#14) by @passsy.
 - **DOCS**: removed outdated doc comment for Listenable.watch().

## 3.2.0

 - **FEAT**: async_listenable support integration.
 - **FIX**: proper handling of synchronous new value notifications during build().

## 3.1.1

 - **DOCS**: Updated README.md.

## 3.1.0

 - **FEAT**: Subscriptions are now kept throughout the Element re-parenting.

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Simplified the API. Every observable type now has only two extension methods: `watch()`, `watchOnly()`.

## 2.0.4

 - **DOCS**: updated README.md.

## 2.0.3

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.

## 2.0.2

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

## 2.0.1

 - **REFACTOR**: updated Flutter SDK constraint.

## 2.0.0-dev.5

 - Fixed initial frame handling

## 2.0.0-dev.4

- `Stream.watch()` and `Future.watch()` now return `AsyncSnapshot`, just like `StreamBuilder` and `FutureBuilder` do
- Performance improvements
- Added example app with benchmarks
- Extracted InheritedContextWatch into a separate package to make it possible to create context watchers for custom observable types

## 1.0.2

- Updated flutter_lints

## 1.0.1

* Added back a workaround for https://github.com/flutter/flutter/issues/128432 to loosen Flutter SDK version constraint.

## 1.0.0

* Initial release.
* `Listenable.watch(context)`, `Stream.watch(context)` extensions.
