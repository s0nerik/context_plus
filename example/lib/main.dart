import 'package:context_plus/context_plus.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:url_router/url_router.dart';

import 'routing.dart';

void main() {
  ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextPlus.onError(FlutterError.onError);
  signals.disableSignalsDevTools();
  runApp(const _App());
}

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  late final UrlRouter router;

  @override
  void initState() {
    super.initState();
    Highlighter.initialize(['dart']);
    router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return ContextPlus.root(
      additionalWatchers: [
        SignalContextWatcher.instance,
        MobxObservableWatcher.instance,
        BlocContextWatcher.instance,
        GetxContextWatcher.instance,
      ],
      child: MaterialApp.router(
        routeInformationParser: const _UrlRouteParser(),
        routerDelegate: router,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}

class _UrlRouteParser extends RouteInformationParser<String> {
  const _UrlRouteParser();

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.uri.toString());

  @override
  RouteInformation? restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(configuration));
}
