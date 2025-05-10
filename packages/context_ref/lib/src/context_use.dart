import 'package:flutter/widgets.dart';

import 'context_ref_root.dart';
import 'context_ticker_provider.dart';
import 'ref.dart';

extension ContextUseAPI on BuildContext {
  T use<T>(
    T Function() create, {
    void Function(T value)? dispose,
    Ref? ref,
    Object? key,
  }) {
    final value = ContextRefRoot.of(
      this,
    ).hooks(this).use<T>(create: create, dispose: dispose, ref: ref, key: key);

    // allow `context.vsync` to properly react to `TickerMode` changes
    contextTickerProviders[this]?.tickerModeNotifier = TickerMode.getNotifier(
      this,
    );

    return value;
  }

  T call<T>(
    T Function() create, {
    void Function(T value)? dispose,
    Ref? ref,
    Object? key,
  }) => use<T>(create, dispose: dispose, ref: ref, key: key);
}
