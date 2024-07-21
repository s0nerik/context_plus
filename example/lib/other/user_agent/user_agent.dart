import 'src/user_agent_unsupported.dart'
    if (dart.library.js_util) 'src/user_agent_web.dart';

export 'src/user_agent_unsupported.dart'
    if (dart.library.js_util) 'src/user_agent_web.dart';

bool get isMobileWebKit {
  final agent = userAgent;
  return agent.contains('Mobile') && agent.contains('AppleWebKit');
}
