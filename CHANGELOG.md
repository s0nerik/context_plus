# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-06-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus_core` - `v1.0.1`](#context_plus_core---v101)
 - [`context_ref` - `v3.2.2`](#context_ref---v322)
 - [`context_watch` - `v7.0.2`](#context_watch---v702)
 - [`context_plus_utils` - `v1.0.4`](#context_plus_utils---v104)
 - [`context_watch_base` - `v8.0.2`](#context_watch_base---v802)
 - [`context_plus` - `v6.0.5`](#context_plus---v605)
 - [`context_watch_mobx` - `v5.0.2`](#context_watch_mobx---v502)
 - [`context_watch_getx` - `v5.0.2`](#context_watch_getx---v502)
 - [`context_watch_bloc` - `v5.0.2`](#context_watch_bloc---v502)
 - [`context_watch_signals` - `v5.0.2`](#context_watch_signals---v502)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_watch` - `v7.0.2`
 - `context_plus_utils` - `v1.0.4`
 - `context_watch_base` - `v8.0.2`
 - `context_plus` - `v6.0.5`
 - `context_watch_mobx` - `v5.0.2`
 - `context_watch_getx` - `v5.0.2`
 - `context_watch_bloc` - `v5.0.2`
 - `context_watch_signals` - `v5.0.2`

---

#### `context_plus_core` - `v1.0.1`

 - **REFACTOR**: ContextPlusFrameInfo.isWarmupFrame.
 - **FIX**: don't pre-increment ContextPlusFrameInfo.currentFrameId for a warmup frame.

#### `context_ref` - `v3.2.2`

 - **FIX**: fixed Ref re-binding assertions for a warmup frame in newer Flutter versions.


## 2025-06-15

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch_base` - `v8.0.1`](#context_watch_base---v801)
 - [`context_watch` - `v7.0.1`](#context_watch---v701)
 - [`context_watch_getx` - `v5.0.1`](#context_watch_getx---v501)
 - [`context_watch_mobx` - `v5.0.1`](#context_watch_mobx---v501)
 - [`context_plus` - `v6.0.4`](#context_plus---v604)
 - [`context_watch_bloc` - `v5.0.1`](#context_watch_bloc---v501)
 - [`context_watch_signals` - `v5.0.1`](#context_watch_signals---v501)
 - [`context_plus_utils` - `v1.0.3`](#context_plus_utils---v103)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_watch` - `v7.0.1`
 - `context_watch_getx` - `v5.0.1`
 - `context_watch_mobx` - `v5.0.1`
 - `context_plus` - `v6.0.4`
 - `context_watch_bloc` - `v5.0.1`
 - `context_watch_signals` - `v5.0.1`
 - `context_plus_utils` - `v1.0.3`

---

#### `context_watch_base` - `v8.0.1`

 - **FIX**: better handling of change notifications during dispose.


## 2025-06-10

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v3.2.1`](#context_ref---v321)
 - [`context_plus` - `v6.0.3`](#context_plus---v603)
 - [`context_plus_utils` - `v1.0.2`](#context_plus_utils---v102)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v6.0.3`
 - `context_plus_utils` - `v1.0.2`

---

#### `context_ref` - `v3.2.1`

 - **FIX**: context.use()-based Ref binding fix.


## 2025-05-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v3.2.0`](#context_ref---v320)
 - [`context_plus` - `v6.0.2`](#context_plus---v602)
 - [`context_plus_utils` - `v1.0.1`](#context_plus_utils---v101)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v6.0.2`
 - `context_plus_utils` - `v1.0.1`

---

#### `context_ref` - `v3.2.0`

 - **FEAT**: `context.inheritRefBindingsFrom(otherContext)`.


## 2025-05-27

### Changes

---

Packages with breaking changes:

 - [`context_plus_utils` - `v1.0.0`](#context_plus_utils---v100)

Packages with other changes:

 - [`context_ref` - `v3.1.0`](#context_ref---v310)
 - [`context_plus` - `v6.0.1`](#context_plus---v601)

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_plus_utils` - `v1.0.0`

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v6.0.1`

---

#### `context_plus_utils` - `v1.0.0`

#### `context_ref` - `v3.1.0`

 - **FEAT**: added ability to suppress the "no rebinds" policy for a specific `Ref.bind` or `Ref.bindLazy` call using `allowRebind` parameter.


## 2025-05-23

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_plus_lint` - `v1.0.1`](#context_plus_lint---v101)

---

#### `context_plus_lint` - `v1.0.1`

 - **FIX**: fix trailing comma handling inside `context_use_unique_key` auto-fix for single-parameter .use() calls.


## 2025-05-22

### Changes

---

Packages with breaking changes:

 - [`context_watch_getx` - `v5.0.0`](#context_watch_getx---v500)

Packages with other changes:

 - There are no other changes in this release.

---

#### `context_watch_getx` - `v5.0.0`

 - **BREAKING** **FEAT**: context.use().
 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!


## 2025-05-22

### Changes

---

Packages with breaking changes:

 - [`context_plus_core` - `v1.0.0`](#context_plus_core---v100)
 - [`context_plus_lint` - `v1.0.0`](#context_plus_lint---v100)
 - [`context_watch_getx` - `v4.0.0`](#context_watch_getx---v400)
 - [`context_plus` - `v6.0.0`](#context_plus---v600)
 - [`context_ref` - `v3.0.0`](#context_ref---v300)
 - [`context_watch` - `v7.0.0`](#context_watch---v700)
 - [`context_watch_base` - `v8.0.0`](#context_watch_base---v800)
 - [`context_watch_bloc` - `v5.0.0`](#context_watch_bloc---v500)
 - [`context_watch_mobx` - `v5.0.0`](#context_watch_mobx---v500)
 - [`context_watch_signals` - `v5.0.0`](#context_watch_signals---v500)

Packages with other changes:

 - There are no other changes in this release.

Packages graduated to a stable release (see pre-releases prior to the stable version for changelog entries):

 - `context_plus_core` - `v1.0.0`
 - `context_plus_lint` - `v1.0.0`
 - `context_watch_getx` - `v4.0.0`

---

#### `context_plus_core` - `v1.0.0`

#### `context_plus_lint` - `v1.0.0`

#### `context_watch_getx` - `v4.0.0`

#### `context_plus` - `v6.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_ref` - `v3.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_watch` - `v7.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_watch_base` - `v8.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_watch_bloc` - `v5.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_watch_mobx` - `v5.0.0`

 - **BREAKING** **FEAT**: context.use().

#### `context_watch_signals` - `v5.0.0`

 - **BREAKING** **FEAT**: context.use().


## 2025-05-03

### Changes

---

Packages with breaking changes:

 - [`context_plus` - `v5.0.0`](#context_plus---v500)
 - [`context_ref` - `v2.0.0`](#context_ref---v200)
 - [`context_watch` - `v6.0.0`](#context_watch---v600)
 - [`context_watch_base` - `v7.0.0`](#context_watch_base---v700)
 - [`context_watch_bloc` - `v4.0.0`](#context_watch_bloc---v400)
 - [`context_watch_getx` - `v4.0.0-rc.4`](#context_watch_getx---v400-rc4)
 - [`context_watch_mobx` - `v4.0.0`](#context_watch_mobx---v400)
 - [`context_watch_signals` - `v4.0.0`](#context_watch_signals---v400)

Packages with other changes:

 - There are no other changes in this release.

---

#### `context_plus` - `v5.0.0`

 - **REFACTOR**: applied Dart 3.7 formatting.
 - **DOCS**: Enhance README files for context_plus, context_ref, and context_watch with improved descriptions and examples.
 - **DOCS**: Update README badges to reflect download metrics for context_plus, context_ref, and context_watch.
 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_ref` - `v2.0.0`

 - **REFACTOR**: applied Dart 3.7 formatting.
 - **DOCS**: Enhance README files for context_plus, context_ref, and context_watch with improved descriptions and examples.
 - **DOCS**: Update README badges to reflect download metrics for context_plus, context_ref, and context_watch.
 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch` - `v6.0.0`

 - **REFACTOR**: applied Dart 3.7 formatting.
 - **DOCS**: Enhance README files for context_plus, context_ref, and context_watch with improved descriptions and examples.
 - **DOCS**: Improved README.md.
 - **DOCS**: Update README badges to reflect download metrics for context_plus, context_ref, and context_watch.
 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch_base` - `v7.0.0`

 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch_bloc` - `v4.0.0`

 - **REFACTOR**: applied Dart 3.7 formatting.
 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch_getx` - `v4.0.0-rc.4`

 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch_mobx` - `v4.0.0`

 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!

#### `context_watch_signals` - `v4.0.0`

 - **BREAKING** **FEAT**: watch*() on Listenable/ValueListenable is even more convenient now!


## 2025-03-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v1.4.4`](#context_ref---v144)
 - [`context_watch` - `v5.1.3`](#context_watch---v513)
 - [`context_watch_base` - `v6.0.3`](#context_watch_base---v603)
 - [`context_plus` - `v4.1.4`](#context_plus---v414)
 - [`context_watch_mobx` - `v3.0.3`](#context_watch_mobx---v303)
 - [`context_watch_getx` - `v4.0.0-rc.3`](#context_watch_getx---v400-rc3)
 - [`context_watch_bloc` - `v3.0.3`](#context_watch_bloc---v303)
 - [`context_watch_signals` - `v3.0.4`](#context_watch_signals---v304)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v4.1.4`
 - `context_watch_mobx` - `v3.0.3`
 - `context_watch_getx` - `v4.0.0-rc.3`
 - `context_watch_bloc` - `v3.0.3`
 - `context_watch_signals` - `v3.0.4`

---

#### `context_ref` - `v1.4.4`

 - **FIX**: allow .bind*() inside LayoutBuilder.
 - **FIX**: rebuild dependent widgets upon the key change in .bind(key: ).

#### `context_watch` - `v5.1.3`

 - **FIX**: allow .watch(context) inside LayoutBuilder.

#### `context_watch_base` - `v6.0.3`

 - **FIX**: allow .watch(context) inside LayoutBuilder.


## 2024-11-17

### Changes

---

Packages with breaking changes:

 - [`context_watch_getx` - `v4.0.0-rc.2`](#context_watch_getx---v400-rc2)

Packages with other changes:

 - There are no other changes in this release.

---

#### `context_watch_getx` - `v4.0.0-rc.2`

 - **REFACTOR**: context_watch v3 migration.
 - **REFACTOR**: pubspec.yaml: Updated homepage/repository with proper branch name.
 - **FEAT**: prepare context_watch_getx for initial release.
 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.
 - **BREAKING** **FEAT**: watchEffect() for attaching side effects to the observed data.
 - **BREAKING** **CHORE**: updated get to 5.0.0 RC.


## 2024-11-17

### Changes

---

Packages with breaking changes:

 - [`context_watch_getx` - `v4.0.0`](#context_watch_getx---v400)

Packages with other changes:

 - [`context_watch_signals` - `v3.0.3`](#context_watch_signals---v303)

---

#### `context_watch_getx` - `v4.0.0`

 - **BREAKING** **CHORE**: updated get to 5.0.0 RC.

#### `context_watch_signals` - `v3.0.3`

 - **DOCS**: applied deprecation annotation from updated signals_flutter.


## 2024-09-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v1.4.3`](#context_ref---v143)
 - [`context_watch_base` - `v6.0.2`](#context_watch_base---v602)
 - [`context_plus` - `v4.1.3`](#context_plus---v413)
 - [`context_watch` - `v5.1.2`](#context_watch---v512)
 - [`context_watch_getx` - `v3.0.2`](#context_watch_getx---v302)
 - [`context_watch_bloc` - `v3.0.2`](#context_watch_bloc---v302)
 - [`context_watch_signals` - `v3.0.2`](#context_watch_signals---v302)
 - [`context_watch_mobx` - `v3.0.2`](#context_watch_mobx---v302)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v4.1.3`
 - `context_watch` - `v5.1.2`
 - `context_watch_getx` - `v3.0.2`
 - `context_watch_bloc` - `v3.0.2`
 - `context_watch_signals` - `v3.0.2`
 - `context_watch_mobx` - `v3.0.2`

---

#### `context_ref` - `v1.4.3`

 - **FIX**: added an assert to enforce that bind*() is not called outside the build() method of a BuildContext.

#### `context_watch_base` - `v6.0.2`

 - **FIX**: added an assert to enforce that watch*() is not called outside the build() method of a BuildContext.


## 2024-09-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_watch_base` - `v6.0.1`](#context_watch_base---v601)
 - [`context_plus` - `v4.1.2`](#context_plus---v412)
 - [`context_watch_bloc` - `v3.0.1`](#context_watch_bloc---v301)
 - [`context_watch_mobx` - `v3.0.1`](#context_watch_mobx---v301)
 - [`context_watch_getx` - `v3.0.1`](#context_watch_getx---v301)
 - [`context_watch_signals` - `v3.0.1`](#context_watch_signals---v301)
 - [`context_watch` - `v5.1.1`](#context_watch---v511)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v4.1.2`
 - `context_watch_bloc` - `v3.0.1`
 - `context_watch_mobx` - `v3.0.1`
 - `context_watch_getx` - `v3.0.1`
 - `context_watch_signals` - `v3.0.1`
 - `context_watch` - `v5.1.1`

---

#### `context_watch_base` - `v6.0.1`

 - **FIX**: fixed a rare case where re-activated Element could lose track of its watched variables.


## 2024-09-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`context_ref` - `v1.4.2`](#context_ref---v142)
 - [`context_plus` - `v4.1.1`](#context_plus---v411)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `context_plus` - `v4.1.1`

---

#### `context_ref` - `v1.4.2`

 - **FIX**: fixed a rare case where re-activated Element could lose its Ref providers.


## 2024-09-07

### Changes

---

Packages with breaking changes:

 - [`context_watch_base` - `v6.0.0`](#context_watch_base---v600)
 - [`context_watch_bloc` - `v3.0.0`](#context_watch_bloc---v300)
 - [`context_watch_getx` - `v3.0.0`](#context_watch_getx---v300)
 - [`context_watch_mobx` - `v3.0.0`](#context_watch_mobx---v300)
 - [`context_watch_signals` - `v3.0.0`](#context_watch_signals---v300)

Packages with other changes:

 - [`context_plus` - `v4.1.0`](#context_plus---v410)
 - [`context_watch` - `v5.1.0`](#context_watch---v510)

---

#### `context_watch_base` - `v6.0.0`

 - **FEAT**: Multi-value watching via (obs1, obs2, ...).watch*(context).
 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

#### `context_watch_bloc` - `v3.0.0`

 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

#### `context_watch_getx` - `v3.0.0`

 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

#### `context_watch_mobx` - `v3.0.0`

 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

#### `context_watch_signals` - `v3.0.0`

 - **BREAKING** **FEAT**: simplified callback argument selection API for ContextWatchSubscription.

#### `context_plus` - `v4.1.0`

 - **FEAT**: Multi-value watching via (ref1, ref2, ...).watch*(context).

#### `context_watch` - `v5.1.0`

 - **REFACTOR**: simplified callback argument selection API for ContextWatchSubscription.
 - **REFACTOR**: simplified exports.
 - **FEAT**: Multi-value watching via (obs1, obs2, ...).watch*(context).


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

