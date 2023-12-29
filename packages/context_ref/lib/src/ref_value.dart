import 'dart:async';

typedef RefValueInitializer<T> = T Function();
typedef RefValueDisposer<T> = void Function(T value);

class RefValue<T> {
  RefValue(
    this._initializer, {
    this.lazy = false,
    RefValueDisposer<T>? dispose,
  }) : _dispose = dispose;

  final RefValueInitializer<T> _initializer;
  final RefValueDisposer<T>? _dispose;
  final bool lazy;

  _ValueWrapper<T>? _valueWrapper;

  T get value {
    final wrapper = _valueWrapper ??= _ValueWrapper(_initializer());
    return wrapper.value;
  }

  void dispose() {
    if (_valueWrapper == null) return;

    try {
      if (_dispose != null) {
        _dispose!(value);
      } else {
        _tryDispose(value);
      }
    } finally {
      _valueWrapper = null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefValue &&
          runtimeType == other.runtimeType &&
          _initializer == other._initializer &&
          _dispose == other._dispose &&
          lazy == other.lazy &&
          _valueWrapper == other._valueWrapper;

  @override
  int get hashCode =>
      _initializer.hashCode ^
      _dispose.hashCode ^
      lazy.hashCode ^
      _valueWrapper.hashCode;
}

class _ValueWrapper<T> {
  _ValueWrapper(this.value);

  final T value;
}

void _tryDispose(dynamic obj) {
  runZonedGuarded(
    () => obj.dispose(),
    (error, stack) {
      final errorStr = error.toString();
      if (!errorStr.contains('dispose\$0 is not a function') &&
          !errorStr.contains('has no instance method \'dispose\'')) {
        throw error;
      }
    },
  );
}
