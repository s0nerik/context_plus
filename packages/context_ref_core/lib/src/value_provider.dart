import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class ValueProvider<T> {
  Object? key;

  T Function()? _creator;
  T Function()? get creator => _creator;
  set creator(T Function()? creator) {
    _creator = creator;
  }

  void Function(T value)? _disposer;
  set disposer(void Function(T value)? disposer) {
    _disposer = disposer;
  }

  _ValueWrapper<T>? _valueWrapper;
  T get value => (_valueWrapper ??= _ValueWrapper(_creator!())).value;
  set value(T value) => (_valueWrapper ??= _ValueWrapper(value)).value = value;

  T? get valueOrNull => _valueWrapper?.value;

  void dispose() {
    if (_valueWrapper == null) return;

    try {
      if (_disposer != null) {
        _disposer!(value);
      } else {
        if (value case ChangeNotifier cn) {
          cn.dispose();
        } else {
          tryDispose(value);
        }
      }
    } finally {
      _valueWrapper = null;
    }
  }
}

@internal
extension ShouldUpdateProviderExt<T> on ValueProvider<T> {
  bool shouldUpdateValue(T value) {
    if (_valueWrapper == null) return true;
    return _valueWrapper!.value != value;
  }
}

class _ValueWrapper<T> {
  _ValueWrapper(this.value);

  T value;
}

@internal
void tryDispose(dynamic obj) {
  runZonedGuarded(
    () => obj.dispose(),
    (error, stack) {
      if (error is NoSuchMethodError) {
        return;
      }

      final errorStr = error.toString();
      if (!errorStr.contains('dispose\$0 is not a function') &&
          !errorStr.contains('has no instance method \'dispose\'')) {
        throw error;
      }
    },
  );
}
