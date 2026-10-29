import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/other_models.dart';
import '../../state/app_providers.dart';
import '../widgets/payment_modal.dart';

class ServicesTabView extends ConsumerWidget {
  const ServicesTabView({super.key});

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

  Widget _buildServiceCard(BuildContext context, WidgetRef ref, HouseholdService item) {
    final isGas = item.iconCode == 'flame';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getServiceIconBg(item.iconCode),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_getServiceIcon(item.iconCode), color: _getServiceIconColor(item.iconCode), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.slateDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.formatInt(item.price),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryTeal),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.priceUnit,
                      style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (isGas) ...[
                      TextButton(
                        onPressed: () {
                          ref.read(userProfileProvider.notifier).rewardScoutPoints(15);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gas depot stock confirmed in Rajagiriya! +15 Scout Points 🎉'),
                              backgroundColor: AppTheme.amberAccent,
                            ),
                          );
                        },
                        child: const Text(
                          '+ Report Depot (+15 Pts)',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.amberAccent),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => PaymentModal(
                            title: item.title,
                            amount: item.price,
                            vendorId: item.vendorId,
                            serviceType: 'lifestyle_service',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: isGas ? AppTheme.amberAccent : AppTheme.primaryTeal,
                      ),
                      child: Text(isGas ? 'Book Swap' : 'Book Service', style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
