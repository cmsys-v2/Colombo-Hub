import 'package:flutter/material.dart';
import '../features/shell/screens/main_shell_screen.dart';

export '../features/shell/screens/main_shell_screen.dart';

/// Backward compatibility alias for HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShellScreen();
  }
}
