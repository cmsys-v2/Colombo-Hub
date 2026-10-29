import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/meal_pool_model.dart';
import '../../../state/app_providers.dart';
import '../../../views/widgets/payment_modal.dart';

/// ColomboHub Lunch Pool Screen
/// Corporate office lunch batching:
/// - Daily 10:30 AM order lock cutoff
/// - Pooled flat delivery fee: Rs. 18.00 per meal (saves Rs. 250+ per day)
/// - Bulk drop-off at WTC, Orion City, Access Towers, and Sethsiripaya lobbies at 12:15 PM sharp
/// - Eco-friendly steel tiffin box options.
class LunchPoolScreen extends ConsumerWidget {
  const LunchPoolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lunchItems = ref.watch(lunchItemsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🍱 Corporate Lunch Batching (Lock Cutoff: 10:30 AM)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.slateDark),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Delivered directly to designated office tower lobbies at 12:15 PM sharp',
                              style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldLight,
                          border: Border.all(color: AppTheme.emeraldBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '🚀 42 Orders in WTC Pool',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                            ),
                            Text(
                              'Courier Fee: Rs. 18.00 / person',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.darkTeal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Meals List
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                itemCount: lunchItems.length,
                itemBuilder: (context, index) {
                  final item = lunchItems[index];
                  return _buildMealCard(context, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealPoolModel item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.catererName,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                    ),
                    if (item.isEcoTiffin)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldLight,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.emeraldBorder),
                        ),
                        child: const Text(
                          '🌱 Eco-Tiffin Box',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.slateDark),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CurrencyFormatter.formatLkr(item.price),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.darkTeal),
                    ),
                    Text(
                      '+ Rs. ${item.courierFee.toInt()} pooled delivery',
                      style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Add to Pool', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => PaymentModal(
                        title: 'Lunch Pool: ${item.title}',
                        amount: item.totalPrice,
                        vendorId: item.vendorId,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
