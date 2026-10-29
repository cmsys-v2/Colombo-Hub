import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../screens/main_shell_screen.dart';

class FeedbackPill extends ConsumerWidget {
  const FeedbackPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionChip(
      avatar: const Icon(LucideIcons.lightbulb, size: 16, color: Color(0xFF0F766E)),
      label: const Text('Suggest / Feedback (+25 Pts)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 4,
      onPressed: () {
        ref.read(userScoutPointsProvider.notifier).state += 25;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Feedback logged to Firestore & WhatsApp Bot (+25 Scout Points).')),
        );
      },
    );
  }
}
