import 'package:context_plus/context_plus.dart';
import 'package:context_watch_bloc/context_watch_bloc.dart';
import 'package:context_watch_getx/context_watch_getx.dart';
import 'package:context_watch_mobx/context_watch_mobx.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart' as signals;
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:url_router/url_router.dart';

import 'routing.dart';

void main() {
  ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextPlus.onError(FlutterError.onError);
  signals.signalsDevToolsEnabled = false;
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
    if (kIsWeb) {
      // Disable the built-in context menus on the web so that custom rich text
      // widget contents can be copied properly.
      //
      // Without this, many source code snippets won't be copyable properly.
      BrowserContextMenu.disableContextMenu();
    }
    Highlighter.initialize(['dart', 'yaml']);
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
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1D1E21),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(Colors.white12),
              side: WidgetStateProperty.all(
                const BorderSide(color: Colors.white24),
              ),
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            width: 300,
            backgroundColor: Color(0xFF1A1A1A),
            contentTextStyle: TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white12),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: SegmentedButton.styleFrom(
              foregroundColor: Colors.grey,
              selectedForegroundColor: Colors.white,
              backgroundColor: Colors.black.withValues(alpha: 0.85),
              selectedBackgroundColor: const Color(
                0xFF353535,
              ).withValues(alpha: 0.85),
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ),
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
