import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/other_models.dart';
import '../../state/app_providers.dart';
import '../widgets/payment_modal.dart';

class EatTabView extends ConsumerWidget {
  const EatTabView({super.key});

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

  Widget _buildMealCard(BuildContext context, LunchItem item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: item.isEcoTiffin ? AppTheme.primaryTeal : AppTheme.slateBorder,
          width: item.isEcoTiffin ? 2 : 1,
        ),
      ),
      color: item.isEcoTiffin ? const Color(0xFFF0FDFA).withValues(alpha: 0.5) : Colors.white,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.isEcoTiffin ? AppTheme.primaryTeal : AppTheme.amberLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.isEcoTiffin ? '♻️ Eco-Tiffin Canister' : item.catererName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.isEcoTiffin ? Colors.white : AppTheme.amberAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.slateDark),
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
                      CurrencyFormatter.formatInt(item.price),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryTeal),
                    ),
                    Text(
                      '+ ${CurrencyFormatter.formatInt(item.courierFee)} pooled fee',
                      style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => PaymentModal(
                        title: item.title,
                        amount: item.totalPrice,
                        vendorId: item.vendorId,
                        serviceType: 'meal_pool',
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.isEcoTiffin ? AppTheme.darkTeal : AppTheme.primaryTeal,
                  ),
                  child: Text(item.isEcoTiffin ? 'Order Tiffin' : 'Order Meal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
