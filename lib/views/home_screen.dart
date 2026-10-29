import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme/app_theme.dart';
import '../state/app_providers.dart';
import 'vendor/vendor_portal_drawer.dart';
import 'tabs/stay_tab_view.dart';
import 'tabs/move_tab_view.dart';
import 'tabs/eat_tab_view.dart';
import 'tabs/budget_tab_view.dart';
import 'tabs/courier_tab_view.dart';
import 'tabs/services_tab_view.dart';
import 'tabs/chat_tab_view.dart';
import 'widgets/phone_auth_modal.dart';
import 'widgets/feedback_modal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldLight,
                                border: Border.all(color: AppTheme.emeraldBorder),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.phone, size: 12, color: AppTheme.emeraldGreen),
                                  const SizedBox(width: 6),
                                  Text(
                                    user.phoneNumber,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA7F3D0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      user.isVerified ? 'Verified' : 'Unverified',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF064E3B)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Role Switcher Button
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTeal,
                              border: Border.all(color: AppTheme.tealBorder),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  user.isVendor ? '🏢 Vendor' : '👤 Client',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () {
                                    ref.read(userProfileProvider.notifier).toggleRole();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          !user.isVendor
                                              ? 'Switched to Vendor & Provider Mode'
                                              : 'Switched to Commuter Client Mode',
                                        ),
                                        backgroundColor: AppTheme.slateDark,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryTeal,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Switch',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 7 Horizontal Scrollable Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildTabButton(ref, AppTab.stay, '🏠 Stay & Rooms', activeTab),
                      _buildTabButton(ref, AppTab.move, '🚌 Move & Highway Buses', activeTab),
                      _buildTabButton(ref, AppTab.eat, '🍱 Office Lunch Pool', activeTab),
                      _buildTabButton(ref, AppTab.budget, '📊 Monthly Budget & Split', activeTab),
                      _buildTabButton(ref, AppTab.courier, '📦 Courier & Bus Parcel', activeTab),
                      _buildTabButton(ref, AppTab.services, '🛠️ Household & Services', activeTab),
                      _buildTabButton(ref, AppTab.chat, '💬 Chat & WhatsApp Bot', activeTab),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Dynamic Monetization Banner
          if (monetizationPhase != MonetizationPhase.free)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.amberLight,
              child: Text(
                monetizationPhase == MonetizationPhase.ads
                    ? '📱 Phase 2 Active (10k+ Downloads): Google AdMob Native Card inserted every 10 listings (Zero intrusive popups).'
                    : '⭐ Phase 3 Active (200k+ Downloads): Vendor Pro Tier (Rs. 1,500/mo) & Client VIP Pass (Ad-free, 0% fees, priority Friday bus seats).',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF78350F)),
                textAlign: TextAlign.center,
              ),
            ),

          // Main View Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Vendor Portal Drawer (Visible in Vendor Mode)
                    if (user.isVendor) const VendorPortalDrawer(),

                    // Active Tab View
                    _buildActiveTabView(activeTab),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => const FeedbackModal(),
          );
        },
        backgroundColor: AppTheme.slateDark,
        foregroundColor: Colors.white,
        icon: const Icon(LucideIcons.lightbulb, size: 16, color: Color(0xFFFDE047)),
        label: const Text('Suggest Route / Feedback (+25 Pts)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTabButton(WidgetRef ref, AppTab tab, String label, AppTab activeTab) {
    final isActive = tab == activeTab;
    return InkWell(
      onTap: () {
        ref.read(activeTabProvider.notifier).state = tab;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.lightTeal : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppTheme.primaryTeal : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppTheme.darkTeal : AppTheme.slateDark,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabView(AppTab tab) {
    switch (tab) {
      case AppTab.stay:
        return const StayTabView();
      case AppTab.move:
        return const MoveTabView();
      case AppTab.eat:
        return const EatTabView();
      case AppTab.budget:
        return const BudgetTabView();
      case AppTab.courier:
        return const CourierTabView();
      case AppTab.services:
        return const ServicesTabView();
      case AppTab.chat:
        return const ChatTabView();
    }
  }
}
