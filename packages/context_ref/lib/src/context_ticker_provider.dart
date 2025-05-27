import 'dart:collection';

import 'package:context_ref/src/context_ref_root.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'ref.dart';

extension ContextTickerProviderExt on BuildContext {
  TickerProvider get vsync {
    final provider = ContextRefRoot.of(this).bind(
      context: this,
      ref: _contextTickerProviderRef,
      create: () {
        final p = ContextTickerProvider();
        p.tickerModeNotifier = TickerMode.getNotifier(this);
        contextTickerProviders[this] = p;
        return p;
      },
      dispose: (provider) {
        provider.dispose();
        contextTickerProviders[this] = null;
      },
      key: null,
      allowRebind: true,
    );
    return provider.value;
  }

  static final _contextTickerProviderRef = Ref<ContextTickerProvider>();
}

@internal
final contextTickerProviders = Expando<ContextTickerProvider>(
  'context_ref:ContextTickerProvider',
);

@internal
class ContextTickerProvider extends TickerProvider {
  final _tickers = HashSet<Ticker>.identity();

  ValueListenable<bool>? _tickerModeNotifier;
  set tickerModeNotifier(ValueListenable<bool> notifier) {
    if (notifier == _tickerModeNotifier) return;

    _tickerModeNotifier?.removeListener(_updateTickerMode);
    _tickerModeNotifier = notifier;
    _tickerModeNotifier!.addListener(_updateTickerMode);
    _updateTickerMode();
  }

  void _updateTickerMode() {
    for (final ticker in _tickers) {
      ticker.muted = muted;
    }
  }

  @pragma('vm:prefer-inline')
  bool get muted => !_tickerModeNotifier!.value;

  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = _ContextTicker(
      onTick,
      this,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    )..muted = muted;
    _tickers.add(ticker);
    return ticker;
  }

  void _removeTicker(_ContextTicker ticker) {
    assert(_tickers.contains(ticker));
    _tickers.remove(ticker);
  }

  void dispose() {
    _tickerModeNotifier?.removeListener(_updateTickerMode);
  }
}

class _ContextTicker extends Ticker {
  _ContextTicker(super.onTick, this._creator, {super.debugLabel});

  final ContextTickerProvider _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
