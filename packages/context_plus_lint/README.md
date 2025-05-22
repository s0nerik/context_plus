[![context_plus.webp](https://github.com/s0nerik/context_plus/raw/main/doc/context_plus_anim.webp)](https://context-plus.sonerik.dev)

> Visit [context-plus.sonerik.dev](https://context-plus.sonerik.dev) for more information and interactive examples.

# context_plus_lint

A set of custom lints and auto-fixes that improve the developer experience with [`context_plus`](https://pub.dev/packages/context_plus).

- Detect and auto-fix incorrect `context.use()` before receiving an assertion at runtime
- Automatically create and assign `context.use()`d values to a new `Ref`
- Detect and auto-fix incorrect `Ref` definitions

## Installation

Add `context_plus_lint` to your `pubspec.yaml`
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
