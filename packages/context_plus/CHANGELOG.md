## 4.0.1

 - **DOCS**: README.md update.

## 4.0.0

> Note: This release does *not* contain any breaking API changes.
> 
> This is a major release because the underlying implementation of
> `InheritedContextWatch` and `ContextWatcher` had changed significantly and
> the behavior of `watchOnly()` had been improved to reduce unnecessary rebuilds
> in one of the edge cases.

 - **FEAT**: watchEffect() for attaching side effects to the observed data.

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!

   All cases of conditional `.watch()`'ing are now handled automatically.

## 2.3.1

 - **DOCS**: removed outdated doc comment for Listenable.watch().

## 2.3.0

 - **FEAT**: async_listenable support integration.
 - **FIX**: proper handling of synchronous new value notifications during build().

## 2.2.2

 - Update a dependency to the latest release.

## 2.2.1

 - Update a dependency to the latest release.

## 2.2.0

 - **FEAT**: Added a simplified way of binding the TickerProvider-dependent controllers.

## 2.1.2

 - Update a dependency to the latest release.

## 2.1.1

 - Update a dependency to the latest release.

## 2.1.0

 - **FEAT**: context.unwatch() upon Ref.bind(), Ref.bindLazy(), Ref.bindValue().
 - **DOCS**: Added Ref.bind(), Ref.bindLazy(), Ref.bindValue() to the comparison table.

## 2.0.1

 - **DOCS**: updated README.md.

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING** **CHANGE**: Removed `Ref<ValueListenable>.watchValue()` and `Ref<ValueListenable>.watchValueOnly()`. `Ref<ValueListenable>.watch()` now returns the value, `Ref<Listenable>.watch()` now returns void.

## 1.0.4

 - Update a dependency to the latest release.

## 1.0.3

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.

## 1.0.2

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

## 1.0.1

 - **REFACTOR**: updated Flutter SDK constraint.

## 1.0.0

* Initial release.
