// ============================================================
//  main.dart — App Entry Point
//  Sets up theme, routing, and launches the root shell.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation/app_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for a consistent worm experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar so gradient backgrounds bleed through
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const WormWorldApp());
}

class WormWorldApp extends StatelessWidget {
  const WormWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worm World',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // custom theme defined in theme/app_theme.dart
      home: const AppShell(),    // root shell handles pages + nav bar
    );
  }
}
