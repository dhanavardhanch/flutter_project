import 'dart:developer';
import 'package:flutter/material.dart';
import 'app_settings.dart';

class PageLoadObserver extends NavigatorObserver {
  final Map<Route<dynamic>, DateTime> _startTimes = {};

  @override
  void didPush(Route route, Route? previousRoute) {
    if (!AppSettings.enablePageLoadLogs) return;
    _startTimes[route] = DateTime.now();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (!AppSettings.enablePageLoadLogs) return;
    if (newRoute != null) {
      _startTimes[newRoute] = DateTime.now();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _startTimes.remove(route);
  }

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    if (!AppSettings.enablePageLoadLogs) return;
    if (topRoute == null) return;

    final start = _startTimes[topRoute];
    if (start == null) return;

    final duration = DateTime.now().difference(start).inMilliseconds;

    // 🔥 IMPORTANT FIX: derive screen name safely
    final screenName =
        topRoute.settings.name ??
            topRoute.runtimeType.toString();

    log('⏱ Page [$screenName] loaded in ${duration} ms');

    _startTimes.remove(topRoute);
  }
}
