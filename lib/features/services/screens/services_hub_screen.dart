import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/service_provider_model.dart';
import '../../../state/app_providers.dart';
import '../../../views/widgets/payment_modal.dart';

/// ColomboHub Services Hub Screen
/// Everyday commuter & household essentials in Colombo:
/// - 20L Filtered Water Bottle delivery
/// - Litro & Laugfs Gas Depot availability feed (+15 pts for crowd updates)
/// - Wash & Fold Doorstep Laundry bag-drop
/// - Verified Plumbers, Electricians, and Technicians
/// - Fresh Manning Market vegetable bag subscriptions.
class ServicesHubScreen extends ConsumerWidget {
  const ServicesHubScreen({super.key});

  IconData _getServiceIcon(String code) {
    switch (code) {
      case 'shirt':
        return LucideIcons.shirt;
      case 'carrot':
        return LucideIcons.carrot;
      case 'droplets':
        return LucideIcons.droplets;
      case 'flame':
        return LucideIcons.flame;
      case 'wrench':
        return LucideIcons.wrench;
      default:
        return LucideIcons.packageCheck;
    }
  }

  Color _getServiceIconBg(String code) {
    switch (code) {
      case 'shirt':
        return AppTheme.lightTeal;
      case 'carrot':
        return AppTheme.emeraldLight;
      case 'droplets':
        return const Color(0xFFEFF6FF);
      case 'flame':
        return AppTheme.amberLight;
      case 'wrench':
        return AppTheme.slateLightBg;
      default:
        return AppTheme.lightTeal;
    }
  }

  Color _getServiceIconColor(String code) {
    switch (code) {
      case 'shirt':
        return AppTheme.primaryTeal;
      case 'carrot':
        return AppTheme.emeraldGreen;
      case 'droplets':
        return const Color(0xFF1D4ED8);
      case 'flame':
        return AppTheme.amberAccent;
      case 'wrench':
        return AppTheme.slateDark;
      default:
        return AppTheme.primaryTeal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(householdServicesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.emeraldBorder),
                    ),
                    child: const Icon(LucideIcons.home, size: 28, color: AppTheme.emeraldGreen),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🛠️ Colombo Household & Daily Essentials',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.slateDark),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Verified neighborhood technicians, 20L water refills, live Litro gas depot tracking & laundry drops.',
                          style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid View
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final item = services[index];
                  return _buildServiceCard(context, ref, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, WidgetRef ref, ServiceProviderModel item) {
    final isGas = item.iconCode == 'flame';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getServiceIconBg(item.iconCode),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getServiceIcon(item.iconCode),
                    size: 20,
                    color: _getServiceIconColor(item.iconCode),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.slateDark),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isGas)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'In Stock (120+)',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          CurrencyFormatter.formatLkr(item.price),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.darkTeal),
                        ),
                        Text(
                          ' ${item.priceUnit}',
                          style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                    Text(
                      'Verified Vendor • ID: ${item.vendorId}',
                      style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                if (isGas)
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.camera, size: 14, color: AppTheme.amberAccent),
                    label: const Text('Update (+15 pts)', style: TextStyle(fontSize: 11, color: AppTheme.amberAccent)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.amberBorder),
                      backgroundColor: AppTheme.amberLight,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onPressed: () {
                      ref.read(userProfileProvider.notifier).addScoutPoints(15);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Verified Gas stock update confirmed! +15 Scout points earned.'),
                          backgroundColor: AppTheme.emeraldGreen,
                        ),
                      );
                    },
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => PaymentModal(
                          title: 'Service Order: ${item.title}',
                          amount: item.price,
                          vendorId: item.vendorId,
                        ),
                      );
                    },
                    child: const Text('Order Now', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
