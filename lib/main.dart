import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/services/remote_config_service.dart';
import 'features/shell/screens/main_shell_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await RemoteConfigService().initialize();
  } catch (e) {
    // Allows resilient offline and mock startup
    debugPrint('Firebase & RemoteConfig initialization notice: $e');
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
      home: const MainShellScreen(),
    );
  }
}
