import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract interface class ContextWatchSubscription {
  Object? getData();
  void cancel();
}

abstract class ContextWatcher<TObservable extends Object> {
  var _canNotify = _defaultCanNotify;

  bool _canHandle(Object observable) => observable is TObservable;

  @protected
  @useResult
  @nonVirtual
  bool canNotify(BuildContext context, TObservable observable) =>
      _canNotify(context, observable);

  @protected
  @useResult
  ContextWatchSubscription createSubscription<T>(
    BuildContext context,
    TObservable observable,
  );
}

class InheritedContextWatch extends InheritedWidget {
  const InheritedContextWatch({
    super.key,
    required this.watchers,
    required super.child,
  });

  final List<ContextWatcher> watchers;

  static InheritedContextWatchElement of(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<InheritedContextWatch>()
            as InheritedContextWatchElement?;
    assert(
      element != null,
      'No InheritedContextWatch found. Did you forget to add a ContextWatchRoot widget?',
    );
    return element!;
  }

  @override
  InheritedContextWatchElement createElement() =>
      InheritedContextWatchElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class InheritedContextWatchElement extends InheritedElement {
  InheritedContextWatchElement(super.widget) {
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._canNotify = _canNotify;
    }
  }

  final _contextData = HashMap<BuildContext, _ContextData>.identity();

  bool get _isBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    final frameTimestamp = SchedulerBinding.instance.currentFrameTimeStamp;
    return phase == SchedulerPhase.persistentCallbacks ||
        frameTimestamp == Duration.zero && phase == SchedulerPhase.idle;
  }

  @override
  void updated(covariant InheritedContextWatch oldWidget) {
    super.updated(oldWidget);
    for (final watcher in oldWidget.watchers) {
      watcher._canNotify = _defaultCanNotify;
    }
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._canNotify = _canNotify;
    }
  }

  @nonVirtual
  Object? watch<T>(
    BuildContext context,
    Object observable,
  ) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return null;
    }

    final contextData = _contextData[context] ??= _ContextData();
    final frame = SchedulerBinding.instance.currentFrameTimeStamp;
    contextData.lastFrame = frame;
    contextData.observableLastFrame[observable] = frame;

    final existingSubscription =
        contextData.observableSubscriptions[observable];
    if (existingSubscription != null) {
      return existingSubscription.getData();
    }

    final watcher = (super.widget as InheritedContextWatch)
        .watchers
        .firstWhere((element) => element._canHandle(observable), orElse: () {
      throw StateError('No ContextWatcher found for ${observable.runtimeType}');
    });
    final subscription = watcher.createSubscription<T>(context, observable);
    contextData.observableSubscriptions[observable] = subscription;
    return subscription.getData();
  }

  @nonVirtual
  void updateContextLastFrame(BuildContext context) {
    if (!_isBuildPhase) {
      // Don't update subscriptions outside of the widget's build() method
      return;
    }

    final contextData = _contextData[context] ??= _ContextData();
    contextData.lastFrame = SchedulerBinding.instance.currentFrameTimeStamp;
  }

  @override
  void removeDependent(Element dependent) {
    _unwatchContext(dependent);
    super.removeDependent(dependent);
  }

  @override
  void unmount() {
    for (final contextData in _contextData.values) {
      for (final subscription in contextData.observableSubscriptions.values) {
        subscription.cancel();
      }
    }
    _contextData.clear();
    for (final watcher in (widget as InheritedContextWatch).watchers) {
      watcher._canNotify = _defaultCanNotify;
    }
    super.unmount();
  }

  bool _canNotify(BuildContext context, Object observable) {
    final contextData = _contextData[context];
    if (contextData == null) {
      _unwatch(context, observable);
      return false;
    }

    final lastFrame = contextData.lastFrame;
    final observableLastFrame = contextData.observableLastFrame[observable];
    if (observableLastFrame != lastFrame || !context.mounted) {
      _unwatch(context, observable);
      return false;
    }

    return true;
  }

  void _unwatch(
    BuildContext context,
    Object observable,
  ) {
    final contextData = _contextData[context];
    if (contextData == null) {
      return;
    }

    final subscription = contextData.observableSubscriptions.remove(observable);
    subscription?.cancel();
  }

  void _unwatchContext(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final subscription in contextData.observableSubscriptions.values) {
      subscription.cancel();
    }
  }
}

class _ContextData {
  late Duration lastFrame;
  final observableLastFrame = HashMap<Object, Duration>.identity();
  final observableSubscriptions =
      HashMap<Object, ContextWatchSubscription>.identity();
}

bool _defaultCanNotify(BuildContext context, Object observable) => false;
