# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-08-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v4.0.2`](#context_plus---v402)

---

#### `context_plus` - `v4.0.2`

 - **DOCS**: README.md update.


## 2024-08-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v4.0.1`](#context_plus---v401)
 - [`context_ref` - `v1.4.1`](#context_ref---v141)
 - [`context_watch` - `v5.0.1`](#context_watch---v501)

---

#### `context_plus` - `v4.0.1`

 - **DOCS**: README.md update.

#### `context_ref` - `v1.4.1`

 - **DOCS**: README.md update.

#### `context_watch` - `v5.0.1`

 - **DOCS**: README.md update.


## 2024-08-22

### Changes

---

Packages with breaking changes:

 - [`context_plus` - `v4.0.0`](#context_plus---v400)
 - [`context_watch` - `v5.0.0`](#context_watch---v500)
 - [`context_watch_base` - `v5.0.0`](#context_watch_base---v500)
 - [`context_watch_bloc` - `v2.0.0`](#context_watch_bloc---v200)
 - [`context_watch_getx` - `v2.0.0`](#context_watch_getx---v200)
 - [`context_watch_mobx` - `v2.0.0`](#context_watch_mobx---v200)
 - [`context_watch_signals` - `v2.0.0`](#context_watch_signals---v200)

Packages with other changes:

 - There are no other changes in this release.

---

#### `context_plus` - `v4.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch` - `v5.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch_base` - `v5.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch_bloc` - `v2.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch_getx` - `v2.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch_mobx` - `v2.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.

#### `context_watch_signals` - `v2.0.0`

 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.


## 2024-07-30

### Changes

---

Packages with breaking changes:

 - [`context_plus` - `v3.0.0`](#context_plus---v300)
 - [`context_watch` - `v4.0.0`](#context_watch---v400)
 - [`context_watch_base` - `v4.0.0`](#context_watch_base---v400)

Packages with other changes:

 - [`context_watch_mobx` - `v1.0.7`](#context_watch_mobx---v107)
 - [`context_watch_bloc` - `v1.0.7`](#context_watch_bloc---v107)
 - [`context_watch_signals` - `v1.1.2`](#context_watch_signals---v112)
 - [`context_watch_getx` - `v1.0.5`](#context_watch_getx---v105)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_watch_mobx` - `v1.0.7`
 - `context_watch_bloc` - `v1.0.7`
 - `context_watch_signals` - `v1.1.2`
 - `context_watch_getx` - `v1.0.5`

---

#### `context_plus` - `v3.0.0`

 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!

#### `context_watch` - `v4.0.0`

 - **DOCS**: README.md update.
 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!

#### `context_watch_base` - `v4.0.0`

 - **BREAKING** **FEAT**: goodbye, `context.unwatch()`!


## 2024-07-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v2.3.1`](#context_plus---v231)
 - [`context_ref` - `v1.4.0`](#context_ref---v140)
 - [`context_watch` - `v3.3.0`](#context_watch---v330)
 - [`context_watch_base` - `v3.1.2`](#context_watch_base---v312)
 - [`context_watch_getx` - `v1.0.4`](#context_watch_getx---v104)
 - [`context_watch_bloc` - `v1.0.6`](#context_watch_bloc---v106)
 - [`context_watch_mobx` - `v1.0.6`](#context_watch_mobx---v106)
 - [`context_watch_signals` - `v1.1.1`](#context_watch_signals---v111)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_watch_getx` - `v1.0.4`
 - `context_watch_bloc` - `v1.0.6`
 - `context_watch_mobx` - `v1.0.6`
 - `context_watch_signals` - `v1.1.1`

---

#### `context_plus` - `v2.3.1`

 - **DOCS**: removed outdated doc comment for Listenable.watch().

#### `context_ref` - `v1.4.0`

 - **FEAT**: improve rebuild scheduling for .bindValue().
 - **FEAT**: Ref.bind<AnimationController?>() support.

#### `context_watch` - `v3.3.0`

 - **FEAT**: [context_watch] Removes the rxdart dependency, ValueStreams are still supported! (#14) by @passsy.
 - **DOCS**: removed outdated doc comment for Listenable.watch().

#### `context_watch_base` - `v3.1.2`

 - **FIX**: ensure no markNeedsBuild() after element is unmounted.


## 2024-06-29

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v2.3.0`](#context_plus---v230)
 - [`context_watch` - `v3.2.0`](#context_watch---v320)
 - [`context_watch_base` - `v3.1.1`](#context_watch_base---v311)
 - [`context_watch_signals` - `v1.1.0`](#context_watch_signals---v110)
 - [`context_watch_getx` - `v1.0.3`](#context_watch_getx---v103)
 - [`context_watch_bloc` - `v1.0.5`](#context_watch_bloc---v105)
 - [`context_watch_mobx` - `v1.0.5`](#context_watch_mobx---v105)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_watch_getx` - `v1.0.3`
 - `context_watch_bloc` - `v1.0.5`
 - `context_watch_mobx` - `v1.0.5`

---

#### `context_plus` - `v2.3.0`

 - **FEAT**: async_listenable support integration.

#### `context_watch` - `v3.2.0`

 - **FEAT**: async_listenable support integration.

#### `context_watch_base` - `v3.1.1`

 - **FIX**: proper handling of synchronous new value notifications during build().

#### `context_watch_signals` - `v1.1.0`

 - **FEAT**: Update signals_flutter in context_watch_signals to v5 (#11).


## 2024-03-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch` - `v3.1.1`](#context_watch---v311)
 - [`context_plus` - `v2.2.2`](#context_plus---v222)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v2.2.2`

---

#### `context_watch` - `v3.1.1`

 - **DOCS**: Updated README.md.


## 2024-03-12

### Changes

---

Packages with breaking changes:

 - [`context_watch_signals` - `v1.0.0`](#context_watch_signals---v100)

Packages with other changes:

 - There are no other changes in this release.

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_watch_signals` - `v1.0.0`

---

#### `context_watch_signals` - `v1.0.0`


## 2024-03-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v1.3.0`](#context_ref---v130)
 - [`context_plus` - `v2.2.1`](#context_plus---v221)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v2.2.1`

---

#### `context_ref` - `v1.3.0`

 - **FEAT**: Per-element equality checks for List, Set and Map keys Ref.bind(key: ...).


## 2024-03-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v2.2.0`](#context_plus---v220)
 - [`context_ref` - `v1.2.0`](#context_ref---v120)

---

#### `context_plus` - `v2.2.0`

 - **FEAT**: Added a simplified way of binding the TickerProvider-dependent controllers.

#### `context_ref` - `v1.2.0`

 - **FEAT**: Added a simplified way of binding the TickerProvider-dependent controllers.


## 2024-03-07

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch` - `v3.1.0`](#context_watch---v310)
 - [`context_watch_base` - `v3.1.0`](#context_watch_base---v310)
 - [`context_plus` - `v2.1.2`](#context_plus---v212)
 - [`context_watch_mobx` - `v1.0.4`](#context_watch_mobx---v104)
 - [`context_watch_getx` - `v1.0.2`](#context_watch_getx---v102)
 - [`context_watch_bloc` - `v1.0.4`](#context_watch_bloc---v104)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v2.1.2`
 - `context_watch_mobx` - `v1.0.4`
 - `context_watch_getx` - `v1.0.2`
 - `context_watch_bloc` - `v1.0.4`

---

#### `context_watch` - `v3.1.0`

 - **FEAT**: Subscriptions are now kept throughout the Element re-parenting.

#### `context_watch_base` - `v3.1.0`

 - **FEAT**: Subscriptions are now kept throughout the Element re-parenting.


## 2024-03-06

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v1.1.0`](#context_ref---v110)
 - [`context_plus` - `v2.1.1`](#context_plus---v211)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v2.1.1`

---

#### `context_ref` - `v1.1.0`

 - **FEAT**: Element re-parenting support.


## 2024-03-03

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v2.1.0`](#context_plus---v210)
 - [`context_ref` - `v1.0.4`](#context_ref---v104)

---

#### `context_plus` - `v2.1.0`

 - **FEAT**: context.unwatch() upon Ref.bind(), Ref.bindLazy(), Ref.bindValue().
 - **DOCS**: Added Ref.bind(), Ref.bindLazy(), Ref.bindValue() to the comparison table.

#### `context_ref` - `v1.0.4`

 - **REFACTOR**: extension-based API for both Ref and ReadOnlyRef.


## 2024-02-26

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v2.0.1`](#context_plus---v201)

---

#### `context_plus` - `v2.0.1`

 - **DOCS**: updated README.md.


## 2024-02-26

### Changes

---

Packages with breaking changes:

 - [`context_plus` - `v2.0.0`](#context_plus---v200)
 - [`context_watch` - `v3.0.0`](#context_watch---v300)
 - [`context_watch_base` - `v3.0.0`](#context_watch_base---v300)

Packages with other changes:

 - [`context_watch_bloc` - `v1.0.3`](#context_watch_bloc---v103)
 - [`context_watch_getx` - `v1.0.1`](#context_watch_getx---v101)
 - [`context_watch_mobx` - `v1.0.3`](#context_watch_mobx---v103)

---

#### `context_plus` - `v2.0.0`

 - **BREAKING** **CHANGE**: Removed `Ref<ValueListenable>.watchValue()` and `Ref<ValueListenable>.watchValueOnly()`. `Ref<ValueListenable>.watch()` now returns the value, `Ref<Listenable>.watch()` now returns void.

#### `context_watch` - `v3.0.0`

 - **BREAKING** **REFACTOR**: Simplified the API. Every observable type now has only two extension methods: `watch()`, `watchOnly()`.

#### `context_watch_base` - `v3.0.0`

 - **BREAKING** **REFACTOR**: Simplified the API. Every observable type now has only two extension methods: `watch()`, `watchOnly()`.

#### `context_watch_bloc` - `v1.0.3`

 - **REFACTOR**: context_watch v3 migration.

#### `context_watch_getx` - `v1.0.1`

 - **REFACTOR**: context_watch v3 migration.

#### `context_watch_mobx` - `v1.0.3`

 - **REFACTOR**: context_watch v3 migration.


## 2024-02-21

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch` - `v2.0.4`](#context_watch---v204)
 - [`context_plus` - `v1.0.4`](#context_plus---v104)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v1.0.4`

---

#### `context_watch` - `v2.0.4`

 - **DOCS**: updated README.md.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch_bloc` - `v1.0.2`](#context_watch_bloc---v102)
 - [`context_watch_mobx` - `v1.0.2`](#context_watch_mobx---v102)

---

#### `context_watch_bloc` - `v1.0.2`

 - **REFACTOR**: loosened Flutter SDK constraint.

#### `context_watch_mobx` - `v1.0.2`

 - **REFACTOR**: loosened Flutter SDK constraint.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - [`context_watch_getx` - `v1.0.0`](#context_watch_getx---v100)

Packages with other changes:

 - There are no other changes in this release.

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_watch_getx` - `v1.0.0`

---

#### `context_watch_getx` - `v1.0.0`


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch_mobx` - `v1.0.1`](#context_watch_mobx---v101)

---

#### `context_watch_mobx` - `v1.0.1`

 - **REFACTOR**: context_watch_mobx: pubspec.yaml cleanup.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - [`context_watch_mobx` - `v1.0.0`](#context_watch_mobx---v100)

Packages with other changes:

 - There are no other changes in this release.

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_watch_mobx` - `v1.0.0`

---

#### `context_watch_mobx` - `v1.0.0`


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch_bloc` - `v1.0.1`](#context_watch_bloc---v101)

---

#### `context_watch_bloc` - `v1.0.1`

 - **REFACTOR**: updated context_watch_bloc topics.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - [`context_watch_bloc` - `v1.0.0`](#context_watch_bloc---v100)

Packages with other changes:

 - There are no other changes in this release.

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_watch_bloc` - `v1.0.0`

---

#### `context_watch_bloc` - `v1.0.0`


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v1.0.3`](#context_plus---v103)
 - [`context_ref` - `v1.0.3`](#context_ref---v103)
 - [`context_watch` - `v2.0.3`](#context_watch---v203)

---

#### `context_plus` - `v1.0.3`

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.

#### `context_ref` - `v1.0.3`

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.

#### `context_watch` - `v2.0.3`

 - **REFACTOR**: added topics to context_plus, context_ref, context_watch.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v1.0.2`](#context_plus---v102)
 - [`context_ref` - `v1.0.2`](#context_ref---v102)
 - [`context_watch` - `v2.0.2`](#context_watch---v202)
 - [`context_watch_base` - `v2.0.2`](#context_watch_base---v202)

---

#### `context_plus` - `v1.0.2`

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

#### `context_ref` - `v1.0.2`

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

#### `context_watch` - `v2.0.2`

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.

#### `context_watch_base` - `v2.0.2`

 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.


## 2024-02-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus` - `v1.0.1`](#context_plus---v101)
 - [`context_ref` - `v1.0.1`](#context_ref---v101)
 - [`context_watch` - `v2.0.1`](#context_watch---v201)
 - [`context_watch_base` - `v2.0.1`](#context_watch_base---v201)

---

#### `context_plus` - `v1.0.1`

 - **REFACTOR**: updated Flutter SDK constraint.

#### `context_ref` - `v1.0.1`

 - **REFACTOR**: updated Flutter SDK constraint.

#### `context_watch` - `v2.0.1`

 - **REFACTOR**: updated Flutter SDK constraint.

#### `context_watch_base` - `v2.0.1`

 - **REFACTOR**: updated Flutter SDK constraint.

