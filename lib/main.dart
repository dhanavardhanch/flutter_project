import 'package:flutter/material.dart';
import 'auth/login_screen.dart';          // ✅ ADD THIS
import 'opening_app/splash_screen.dart';  // keep
import 'activity_logger.dart';            // keep

void main() async {
  // Required before any async call
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ Load logs BEFORE app starts
  await ActivityLogger.initialize();

  runApp(const TGApp());
}

class TGApp extends StatelessWidget {
  const TGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theme stays same
      theme: ThemeData(
        primaryColor: const Color(0xFF00AEEF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Roboto",
      ),

      // ✅ LOGIN FIRST
      home: const LoginScreen(),
    );
  }
}
