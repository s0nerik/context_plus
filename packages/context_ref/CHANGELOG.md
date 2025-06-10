## 3.2.1

 - **FIX**: context.use()-based Ref binding fix.

## 3.2.0

 - **FEAT**: `context.inheritRefBindingsFrom(otherContext)`.

## 3.1.0

 - **FEAT**: added ability to suppress the "no rebinds" policy for a specific `Ref.bind` or `Ref.bindLazy` call using `allowRebind` parameter.

## 3.0.0

> Note: There are no breaking API changes this release.
> 
> This is a major release mostly because of significant internal changes.

Easy to use, universal hooks are here!

 - **FEAT**: `context.use()`
 - **FEAT**: Added `context.vsync` to be used together with `context.use()` for accessing a `TickerProvider` instance for this context.
 - **REFACTOR**: Significant internal code changes aimed at maximizing the performance and unifying the logic for attaching data to a `BuildContext` among all `context_*` packages.

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING**: Increased required Dart version to 3.7.0

## 1.4.4

 - **FIX**: allow .bind*() inside LayoutBuilder.
 - **FIX**: rebuild dependent widgets upon the key change in .bind(key: ).

## 1.4.3

 - **FIX**: added an assert to enforce that bind*() is not called outside the build() method of a BuildContext.

## 1.4.2

 - **FIX**: fixed a rare case where re-activated Element could lose its Ref providers.

## 1.4.1

 - **DOCS**: README.md update.

## 1.4.0

 - **FEAT**: improve rebuild scheduling for .bindValue().
 - **FEAT**: Ref.bind<AnimationController?>() support.

## 1.3.0

 - **FEAT**: Per-element equality checks for List, Set and Map keys Ref.bind(key: ...).

## 1.2.0

 - **FEAT**: Added a simplified way of binding the TickerProvider-dependent controllers.

## 1.1.0

 - **FEAT**: Element re-parenting support.

## 1.0.4

 - **REFACTOR**: extension-based API for both Ref and ReadOnlyRef.

## 1.0.3

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.

## 1.0.2

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

## 1.0.1

 - **REFACTOR**: updated Flutter SDK constraint.

## 1.0.0

* Initial release.
