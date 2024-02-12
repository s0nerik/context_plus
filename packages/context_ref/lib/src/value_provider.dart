import 'dart:async';

import 'package:meta/meta.dart';

@internal
class ValueProvider<T> {
  Object? _key;
  set key(Object? key) {
    if (_key == key) {
      return;
    }
    dispose();
    _key = key;
  }

  T Function()? _creator;
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

  void dispose() {
    if (_valueWrapper == null) return;

    try {
      if (_disposer != null) {
        _disposer!(value);
      } else {
        _tryDispose(value);
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

void _tryDispose(dynamic obj) {
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
