import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../stay/screens/stay_map_screen.dart';
import '../../budget/screens/budget_planner_screen.dart';
import '../../courier/screens/courier_screen.dart';
import '../../services/screens/services_hub_screen.dart';
import '../../lunch_pool/screens/lunch_pool_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../widgets/feedback_pill.dart';

final isVendorModeProvider = StateProvider<bool>((ref) => false);
final userScoutPointsProvider = StateProvider<int>((ref) => 550);
final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVendor = ref.watch(isVendorModeProvider);
    final points = ref.watch(userScoutPointsProvider);
    final tabIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('CH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ColomboHub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('⭐ $points Scout Points • Verified', style: const TextStyle(fontSize: 11, color: Color(0xFF0F766E))),
              ],
            ),
          ],
        ),
        actions: [
          // 1-Tap Client <-> Vendor Switching Header
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isVendor ? const Color(0xFFFEF3C7) : const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(isVendor ? LucideIcons.store : LucideIcons.userCheck, size: 16),
                const SizedBox(width: 4),
                Text(
                  isVendor ? 'Vendor' : 'Client',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isVendor,
                  activeThumbColor: const Color(0xFFD97706),
                  onChanged: (val) => ref.read(isVendorModeProvider.notifier).state = val,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: tabIndex,
            children: const [
              StayMapScreen(),
              BudgetPlannerScreen(),
              CourierScreen(),
              ServicesHubScreen(),
              LunchPoolScreen(),
              ChatScreen(),
            ],
          ),
          const Positioned(
            right: 16,
            bottom: 16,
            child: FeedbackPill(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (idx) => ref.read(selectedTabProvider.notifier).state = idx,
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.home), label: 'Stay'),
          NavigationDestination(icon: Icon(LucideIcons.wallet), label: 'Budget'),
          NavigationDestination(icon: Icon(LucideIcons.package), label: 'Courier'),
          NavigationDestination(icon: Icon(LucideIcons.wrench), label: 'Services'),
          NavigationDestination(icon: Icon(LucideIcons.utensils), label: 'Lunch Pool'),
          NavigationDestination(icon: Icon(LucideIcons.messageSquare), label: 'Chat'),
        ],
      ),
    );
  }
}
