import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ContextPlusElementProxy implements Element {
  ContextPlusElementProxy(
    this._element,
    this._onMarkNeedsBuild,
  );

  Element get actualElement => _element;

  final Element _element;
  final VoidCallback? _onMarkNeedsBuild;

  @override
  void markNeedsBuild() {
    if (_onMarkNeedsBuild != null) {
      _onMarkNeedsBuild!();
    } else {
      _element.markNeedsBuild();
    }
  }

  ///
  /// Proxied [Element] method implementations
  ///

  @override
  bool get debugDoingBuild => _element.debugDoingBuild;

  @override
  DiagnosticsNode describeElement(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) =>
      _element.describeElement(name, style: style);

  @override
  List<DiagnosticsNode> describeMissingAncestor({
    required Type expectedAncestorType,
  }) =>
      _element.describeMissingAncestor(
        expectedAncestorType: expectedAncestorType,
      );

  @override
  DiagnosticsNode describeOwnershipChain(String name) =>
      _element.describeOwnershipChain(name);

  @override
  DiagnosticsNode describeWidget(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) =>
      _element.describeWidget(name, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      _element.debugFillProperties(properties);

  @override
  void activate() => _element.activate();

  @override
  void deactivate() => _element.deactivate();

  @override
  void debugDeactivated() => _element.debugDeactivated();

  @override
  void unmount() => _element.unmount();

  @override
  bool get mounted => _element.mounted;

  @override
  bool get dirty => _element.dirty;

  @override
  Widget get widget => _element.widget;

  @override
  BuildOwner? get owner => _element.owner;

  @override
  Size? get size => _element.size;

  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) =>
      _element.dependOnInheritedElement(ancestor, aspect: aspect);

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) =>
      _element.dependOnInheritedWidgetOfExactType<T>(aspect: aspect);

  @override
  void didChangeDependencies() => _element.didChangeDependencies();

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() =>
      _element.findAncestorRenderObjectOfType<T>();

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() =>
      _element.findAncestorStateOfType<T>();

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() =>
      _element.findAncestorWidgetOfExactType<T>();

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() =>
      _element.findRootAncestorStateOfType<T>();

  @override
  InheritedElement?
      getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() =>
          _element.getElementForInheritedWidgetOfExactType<T>();

  @override
  void visitAncestorElements(bool Function(Element element) visitor) =>
      _element.visitAncestorElements(visitor);

  @override
  void visitChildElements(ElementVisitor visitor) =>
      _element.visitChildElements(visitor);

  @override
  Object? get slot => _element.slot;

  @override
  int get depth => _element.depth;

  @override
  void mount(Element? parent, Object? newSlot) =>
      _element.mount(parent, newSlot);

  @override
  void update(covariant Widget newWidget) => _element.update(newWidget);

  @override
  void attachNotificationTree() => _element.attachNotificationTree();

  @override
  void attachRenderObject(Object? newSlot) =>
      _element.attachRenderObject(newSlot);

  @override
  BuildScope get buildScope => _element.buildScope;

  @override
  void deactivateChild(Element child) => _element.deactivateChild(child);

  @override
  bool debugExpectsRenderObjectForSlot(Object? slot) =>
      _element.debugExpectsRenderObjectForSlot(slot);

  @override
  String debugGetCreatorChain(int limit) =>
      _element.debugGetCreatorChain(limit);

  @override
  List<Element> debugGetDiagnosticChain() => _element.debugGetDiagnosticChain();

  @override
  bool get debugIsActive => _element.debugIsActive;

  @override
  bool get debugIsDefunct => _element.debugIsDefunct;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) =>
      _element.debugVisitOnstageChildren(visitor);

  @override
  void detachRenderObject() => _element.detachRenderObject();

  @override
  void dispatchNotification(Notification notification) =>
      _element.dispatchNotification(notification);

  @override
  bool doesDependOnInheritedElement(InheritedElement ancestor) =>
      _element.doesDependOnInheritedElement(ancestor);

  @override
  RenderObject? findRenderObject() => _element.findRenderObject();

  @override
  void forgetChild(Element child) => _element.forgetChild(child);

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() =>
      _element.getInheritedWidgetOfExactType<T>();

  @override
  Element inflateWidget(Widget newWidget, Object? newSlot) =>
      _element.inflateWidget(newWidget, newSlot);

  @override
  void performRebuild() => _element.performRebuild();

  @override
  void reassemble() => _element.reassemble();

  @override
  void rebuild({bool force = false}) => _element.rebuild(force: force);

  @override
  RenderObject? get renderObject => _element.renderObject;

  @override
  Element? get renderObjectAttachingChild =>
      _element.renderObjectAttachingChild;

  @override
  Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) =>
      _element.updateChild(child, newWidget, newSlot);

  @override
  List<Element> updateChildren(
    List<Element> oldChildren,
    List<Widget> newWidgets, {
    Set<Element>? forgottenChildren,
    List<Object?>? slots,
  }) =>
      _element.updateChildren(
        oldChildren,
        newWidgets,
        forgottenChildren: forgottenChildren,
        slots: slots,
      );

  @override
  void updateSlot(Object? newSlot) => _element.updateSlot(newSlot);

  @override
  void updateSlotForChild(Element child, Object? newSlot) =>
      _element.updateSlotForChild(child, newSlot);

  @override
  void visitChildren(ElementVisitor visitor) => _element.visitChildren(visitor);

  @override
  List<DiagnosticsNode> debugDescribeChildren() =>
      _element.debugDescribeChildren();

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      _element.toDiagnosticsNode(name: name, style: style);

  @override
  String toStringDeep({
    String prefixLineOne = '',
    String? prefixOtherLines,
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
    int wrapWidth = 65,
  }) =>
      _element.toStringDeep(
        prefixLineOne: prefixLineOne,
        prefixOtherLines: prefixOtherLines,
        minLevel: minLevel,
        wrapWidth: wrapWidth,
      );

  @override
  String toStringShallow({
    String joiner = ', ',
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) =>
      _element.toStringShallow(joiner: joiner, minLevel: minLevel);

  @override
  String toStringShort() => _element.toStringShort();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      _element.toString(minLevel: minLevel);
}
