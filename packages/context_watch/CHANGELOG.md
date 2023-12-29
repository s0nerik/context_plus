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
