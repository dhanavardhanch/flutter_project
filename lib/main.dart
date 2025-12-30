import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'activity_logger.dart';

// ✅ REQUIRED FOR PAGE LOAD TIMING (GLOBAL)
import 'utils/page_load_observer.dart';

void main() async {
  // Required before any async call
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ Load activity logs BEFORE app starts
  await ActivityLogger.initialize();

  runApp(const TGApp());
}

class TGApp extends StatelessWidget {
  const TGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ GLOBAL PAGE LOAD OBSERVER (ONE PLACE ONLY)
      navigatorObservers: [
        PageLoadObserver(),
      ],

      // ✅ GLOBAL THEME
      theme: ThemeData(
        primaryColor: const Color(0xFF00AEEF),
        scaffoldBackgroundColor: Colors.white,

        // ✅ GLOBAL FONT
        fontFamily: 'Montserrat',
      ),

      // ✅ START SCREEN
      home: const LoginScreen(),
    );
  }
}
