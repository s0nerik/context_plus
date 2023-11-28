import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
final class AsyncSnapshotGenerator<TKey> {
  final _connectionState = HashMap<TKey, ConnectionState>();
  final _data = HashMap<TKey, dynamic>();
  final _error = HashMap<TKey, Object>();
  final _errorTrace = HashMap<TKey, StackTrace?>();

  ConnectionState? getConnectionState(TKey? key) {
    if (key == null) {
      return null;
    }
    return _connectionState[key];
  }

  void setConnectionState(TKey key, ConnectionState connectionState) {
    _connectionState[key] = connectionState;
  }

  void setData(TKey key, dynamic data) {
    _error.remove(key);
    _errorTrace.remove(key);
    _data[key] = data;
  }

  void setError(TKey key, Object error, [StackTrace? stackTrace]) {
    _data.remove(key);
    _error[key] = error;
    _errorTrace[key] = stackTrace;
  }

  void clear(TKey key) {
    _connectionState.remove(key);
    _data.remove(key);
    _error.remove(key);
    _errorTrace.remove(key);
  }

  AsyncSnapshot<T> generate<T>(TKey? key) {
    if (key == null) {
      return AsyncSnapshot<T>.waiting();
    }

    final connectionState = _connectionState[key];
    final data = _data[key];
    final error = _error[key];
    final stackTrace = _errorTrace[key];

    if (connectionState == null) {
      return AsyncSnapshot<T>.waiting();
    }
    if (data != null) {
      return AsyncSnapshot<T>.withData(connectionState, data);
    }
    if (error != null) {
      if (stackTrace != null) {
        return AsyncSnapshot<T>.withError(
          connectionState,
          error,
          stackTrace,
        );
      }
      return AsyncSnapshot<T>.withError(
        connectionState,
        error,
      );
    }
    return AsyncSnapshot<T>.nothing().inState(connectionState);
  }
}
