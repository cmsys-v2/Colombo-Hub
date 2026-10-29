import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Allows offline demo and resilience during development
    debugPrint('Firebase initialization notice: $e');
  }

  runApp(
    const ProviderScope(
      child: ColomboHubApp(),
    ),
  );
}

class ColomboHubApp extends StatelessWidget {
  const ColomboHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColomboHub Super-App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
