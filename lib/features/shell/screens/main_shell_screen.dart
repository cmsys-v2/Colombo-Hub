import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/app_providers.dart';
import '../../../views/vendor/vendor_portal_drawer.dart';
import '../../../views/widgets/feedback_modal.dart';
import '../../../views/widgets/phone_auth_modal.dart';
import '../../budget/screens/budget_planner_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../courier/screens/courier_screen.dart';
import '../../lunch_pool/screens/lunch_pool_screen.dart';
import '../../services/screens/services_hub_screen.dart';
import '../../stay/screens/stay_map_screen.dart';
import '../../transport/screens/transport_screen.dart';
import '../widgets/feedback_pill.dart';

/// ColomboHub Main Shell Screen
/// Primary responsive container for Android, iOS, and Web.
/// Hosts persistent navigation (Stay, Transport, Lunch Pool, Budget, Courier, Services, Chat),
/// real-time Scout points counter, carrier detection indicator, and Remote Config monetization banner.
class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final activeTab = ref.watch(activeTabProvider);
    final monetizationPhase = ref.watch(monetizationPhaseProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(115),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppTheme.slateBorder)),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Header Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo & Branding
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryTeal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CH',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ColomboHub Ecosystem',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.slateDark),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '⭐ ${user.scoutPoints} Scout Points',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppTheme.emeraldLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Verified Scout',
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(width: 24),

                      // User Controls
                      Row(
                        children: [
                          // Phone Auth Button
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => const PhoneAuthModal(),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.slateLightBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.slateBorder),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    user.isVerified ? LucideIcons.phoneCall : LucideIcons.phone,
                                    size: 13,
                                    color: user.isVerified ? AppTheme.emeraldGreen : AppTheme.slateDark,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    user.isVerified ? user.phoneNumber : 'Sign In',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                                  ),
                                  if (user.isVerified) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightTeal,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        user.carrier,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Vendor Portal Button
                          Builder(
                            builder: (context) {
                              return OutlinedButton.icon(
                                icon: const Icon(LucideIcons.store, size: 13),
                                label: const Text('Partner Portal', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Monetization & Feature Flag Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppTheme.lightTeal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryTeal,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PHASE: ${monetizationPhase.toUpperCase()}',
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Form-C Ready Stays • 0% Commission Beta for Landlords & Caterers',
                              style: TextStyle(fontSize: 10, color: AppTheme.darkTeal, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        InkWell(
                          onTap: () {
                            ref.read(monetizationPhaseProvider.notifier).cyclePhase();
                          },
                          child: const Text(
                            'Cycle Phase ⚙️',
                            style: TextStyle(fontSize: 10, color: AppTheme.slateMuted, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: const VendorPortalDrawer(),
      body: Row(
        children: [
          // Left Rail for Desktop / Wide screens
          LayoutBuilder(
            builder: (context, constraints) {
              if (MediaQuery.of(context).size.width >= 900) {
                return NavigationRail(
                  selectedIndex: activeTab.index,
                  onDestinationSelected: (idx) => ref.read(activeTabProvider.notifier).setTab(idx),
                  labelType: NavigationRailLabelType.all,
                  leading: const SizedBox(height: 8),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(LucideIcons.home), label: Text('Stay')),
                    NavigationRailDestination(icon: Icon(LucideIcons.bus), label: Text('Move')),
                    NavigationRailDestination(icon: Icon(LucideIcons.utensils), label: Text('Eat')),
                    NavigationRailDestination(icon: Icon(LucideIcons.calculator), label: Text('Budget')),
                    NavigationRailDestination(icon: Icon(LucideIcons.packageCheck), label: Text('Courier')),
                    NavigationRailDestination(icon: Icon(LucideIcons.wrench), label: Text('Services')),
                    NavigationRailDestination(icon: Icon(LucideIcons.messageSquare), label: Text('Chat')),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Main View Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IndexedStack(
                index: activeTab.index,
                children: const [
                  StayMapScreen(),
                  TransportScreen(),
                  LunchPoolScreen(),
                  BudgetPlannerScreen(),
                  CourierScreen(),
                  ServicesHubScreen(),
                  ChatScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (MediaQuery.of(context).size.width < 900) {
            return NavigationBar(
              selectedIndex: activeTab.index,
              onDestinationSelected: (idx) => ref.read(activeTabProvider.notifier).setTab(idx),
              destinations: const [
                NavigationDestination(icon: Icon(LucideIcons.home), label: 'Stay'),
                NavigationDestination(icon: Icon(LucideIcons.bus), label: 'Move'),
                NavigationDestination(icon: Icon(LucideIcons.utensils), label: 'Eat'),
                NavigationDestination(icon: Icon(LucideIcons.calculator), label: 'Budget'),
                NavigationDestination(icon: Icon(LucideIcons.packageCheck), label: 'Courier'),
                NavigationDestination(icon: Icon(LucideIcons.wrench), label: 'Services'),
                NavigationDestination(icon: Icon(LucideIcons.messageSquare), label: 'Chat'),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FeedbackPill(
        onCustomTap: () {
          showDialog(
            context: context,
            builder: (ctx) => const FeedbackModal(),
          );
        },
      ),
    );
  }
}
