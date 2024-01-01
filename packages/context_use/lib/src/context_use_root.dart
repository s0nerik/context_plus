import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'provider.dart';

class ContextUseRoot extends InheritedWidget {
  const ContextUseRoot({
    super.key,
    required super.child,
  });

  static InheritedContextUseElement of(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<ContextUseRoot>()
            as InheritedContextUseElement?;
    assert(
      element != null,
      'ContextUseRoot not found. Did you forget to add a ContextUseRoot widget?',
    );
    return element!;
  }

  @override
  InheritedContextUseElement createElement() =>
      InheritedContextUseElement(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class InheritedContextUseElement extends InheritedElement {
  InheritedContextUseElement(super.widget);

  final _contextData = HashMap<BuildContext, _ContextData>.identity();

  Provider<T> use<T>({
    required BuildContext context,
    required T Function() create,
    required void Function(T instance)? dispose,
    required bool lazy,
    required Object? key,
  }) {
    final contextData = _contextData[context] ??= _ContextData();

    if (contextData.lastFrame !=
        SchedulerBinding.instance.currentFrameTimeStamp) {
      contextData.lastFrame = SchedulerBinding.instance.currentFrameTimeStamp;
      contextData.lastIndex = 0;
    }

    final index = contextData.lastIndex++;

    final existingProvider = contextData.providers.getOrNull(index);
    if (existingProvider != null) {
      final existingKey = contextData.keys.getOrNull(index);
      if (existingKey == key) {
        return existingProvider as Provider<T>;
      } else {
        _disposeProvider(existingProvider);
      }
    }

    final provider = Provider<T>(create, dispose: dispose, lazy: lazy);
    contextData.keys.set(index, key);
    contextData.providers.set(index, provider);
    return provider;
  }

  @override
  void removeDependent(Element dependent) {
    _disposeProvidersForContext(dependent);
    super.removeDependent(dependent);
  }

  @override
  void unmount() {
    for (final contextData in _contextData.values) {
      for (final provider in contextData.providers) {
        provider.dispose();
      }
    }
    _contextData.clear();
    super.unmount();
  }

  void _disposeProvidersForContext(BuildContext context) {
    final contextData = _contextData.remove(context);
    if (contextData == null) {
      return;
    }

    for (final provider in contextData.providers) {
      _disposeProvider(provider);
    }
  }
}

void _disposeProvider<T>(Provider<T> provider) {
  if (!kDebugMode) {
    provider.dispose();
    return;
  }

  try {
    provider.dispose();
  } catch (e) {
    if (e.runtimeType.toString() != '_CompileTimeError') {
      // This happens during hot reload if the provided type has been renamed.
      rethrow;
    }
  }
}

class _ContextData {
  var lastFrame = Duration.zero;
  var lastIndex = 0;

  final keys = <Object?>[];
  final providers = <Provider>[];
}

extension _ListExtension<T> on List<T> {
  T? getOrNull(int index) => index < length ? this[index] : null;
  void set(int index, T value) {
    if (index < length) {
      this[index] = value;
    } else {
      add(value);
    }
  }
}
