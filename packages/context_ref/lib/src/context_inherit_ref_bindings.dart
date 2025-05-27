import 'package:flutter/widgets.dart';

import 'context_ref_root.dart';

extension ContextInheritRefBindingsAPI on BuildContext {
  /// Allow accessing [Ref] bindings of the [otherContext] in the current context.
  ///
  /// This is useful for accessing the [Ref] bindings of a parent page within
  /// anything pushed into the [Overlay] on top of it (e.g. dialogs, sheets, etc.).
  ///
  /// Bindings can be inherited only from a single [otherContext]. Calling
  /// [inheritRefBindingsFrom] multiple times will override the previous
  /// inherited context for all future lookups.
  void inheritRefBindingsFrom(BuildContext otherContext) {
    ContextRefRoot.of(
      this,
    ).setInheritedElement(this as Element, otherContext as Element);
  }
}
