import 'dart:async';

class Provider<T> {
  Provider(
    this._initializer, {
    required this.lazy,
    required void Function(T value)? dispose,
  }) : _dispose = dispose;

  final T Function() _initializer;
  final void Function(T value)? _dispose;
  final bool lazy;

  _ValueWrapper<T>? _valueWrapper;

  T get value {
    final wrapper = _valueWrapper ??= _ValueWrapper(_initializer());
    return wrapper.value;
  }

  set value(T value) {
    final wrapper = _valueWrapper ??= _ValueWrapper(value);
    wrapper.value = value;
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
      other is Provider &&
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

  T value;
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
