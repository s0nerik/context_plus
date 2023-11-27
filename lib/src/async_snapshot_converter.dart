import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@internal
AsyncSnapshot<T> convertAsyncSnapshot<T>(AsyncSnapshot? snapshot) {
  if (snapshot == null) {
    return AsyncSnapshot<T>.waiting();
  }
  if (snapshot.data != null) {
    return AsyncSnapshot<T>.withData(snapshot.connectionState, snapshot.data);
  }
  if (snapshot.error != null) {
    if (snapshot.stackTrace != null) {
      return AsyncSnapshot<T>.withError(
        snapshot.connectionState,
        snapshot.error!,
        snapshot.stackTrace!,
      );
    }
    return AsyncSnapshot<T>.withError(
      snapshot.connectionState,
      snapshot.error!,
    );
  }
  return AsyncSnapshot<T>.nothing().inState(snapshot.connectionState);
}
