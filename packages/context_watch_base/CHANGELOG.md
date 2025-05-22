## 8.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: context.use().

## 7.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

## 6.0.3

 - **FIX**: allow .watch(context) inside LayoutBuilder.

## 6.0.2

 - **FIX**: added an assert to enforce that watch*() is not called outside the build() method of a BuildContext.

## 6.0.1

 - **FIX**: fixed a rare case where re-activated Element could lose track of its watched variables.

## 6.0.0

> Note: This release has breaking changes.

 - **FEAT**: Multi-value watching via (obs1, obs2, ...).watch*(context).
 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

## 5.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.
 - Enhanced `ContextWatchSubscription` interface
 - Simplified and optimized the `InheritedContextWatch` implementation

## 4.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!

## 3.1.2

 - **FIX**: ensure no markNeedsBuild() after element is unmounted.

## 3.1.1

 - **FIX**: proper handling of synchronous new value notifications during build().

## 3.1.0

 - **FEAT**: Subscriptions are now kept throughout the Element re-parenting.

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Simplified the API. Every observable type now has only two extension methods: `watch()`, `watchOnly()`.

## 2.0.2

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

## 2.0.1

 - **REFACTOR**: updated Flutter SDK constraint.

## 2.0.0-dev.5

 - Fixed initial frame handling

## 1.0.0-dev.1

- Extracted InheritedContextWatch into a separate package to make it possible to create context watchers for custom observable types
