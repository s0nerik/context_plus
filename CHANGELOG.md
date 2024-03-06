# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

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

