import 'package:flutter/foundation.dart';

class RefGenericTypeRenamedHotReloadError implements Error {
  RefGenericTypeRenamedHotReloadError._(this.oldType, this.newType);

  final String oldType;
  final String newType;

  @override
  String toString() =>
      'Ref<$oldType> was renamed to Ref<$newType>, which is not supported by hot reload. Do a hot restart instead.';

  @override
  StackTrace? get stackTrace => null;

  static final _regex = RegExp(
    r'[\w\W]*?Ref<(?<old_type>.+?)>[\w\W]*?is not a subtype of type[\w\W]*?Ref<(?<new_type>.+?)>',
  );

  static RefGenericTypeRenamedHotReloadError? create(Object error) {
    if (!kDebugMode) return null;
    if (error is! TypeError) return null;

    final match = _regex.firstMatch(error.toString());
    if (match == null) return null;

    final oldType = match.namedGroup('old_type')!;
    final newType = match.namedGroup('new_type')!;
    return RefGenericTypeRenamedHotReloadError._(oldType, newType);
  }
}
