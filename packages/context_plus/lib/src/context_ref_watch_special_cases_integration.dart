import 'package:context_ref/context_ref.dart' as context_ref;
import 'package:context_watch/context_watch.dart' as context_watch;
import 'package:flutter/material.dart';

extension AnimationControllerRefAPI<
        TAnimationController extends AnimationController>
    on context_ref.Ref<TAnimationController> {
  /// Binds the provided [TAnimationController] to the [context].
  TAnimationController bind(
    BuildContext context,
    TAnimationController Function(TickerProvider vsync) create, {
    void Function(TAnimationController controller)? dispose,
    Object? key,
  }) {
    context.unwatch();
    return context_ref.AnimationControllerRefAPI(this)
        .bind(context, create, dispose: dispose, key: key);
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the
  /// controller is requested for the first.
  void bindLazy(
    BuildContext context,
    TAnimationController Function(TickerProvider vsync) create, {
    void Function(TAnimationController controller)? dispose,
    Object? key,
  }) {
    context.unwatch();
    context_ref.AnimationControllerRefAPI(this)
        .bindLazy(context, create, dispose: dispose, key: key);
  }
}

extension TabControllerRefAPI<TTabController extends TabController>
    on context_ref.Ref<TTabController> {
  /// Binds the provided [TTabController] to the [context].
  TTabController bind(
    BuildContext context,
    TTabController Function(TickerProvider vsync) create, {
    void Function(TTabController controller)? dispose,
    Object? key,
  }) {
    context.unwatch();
    return context_ref.TabControllerRefAPI(this)
        .bind(context, create, dispose: dispose, key: key);
  }

  /// Same as [bind] but [create] is called lazily, i.e. only when the
  /// controller is requested for the first.
  void bindLazy(
    BuildContext context,
    TTabController Function(TickerProvider vsync) create, {
    void Function(TTabController controller)? dispose,
    Object? key,
  }) {
    context.unwatch();
    context_ref.TabControllerRefAPI(this)
        .bindLazy(context, create, dispose: dispose, key: key);
  }
}
