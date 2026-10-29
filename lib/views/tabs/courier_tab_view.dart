import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/other_models.dart';
import '../../state/app_providers.dart';
import '../widgets/payment_modal.dart';

class CourierTabView extends ConsumerWidget {
  const CourierTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courierOptions = ref.watch(courierOptionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          const Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📦 Multi-Tier Courier & Hometown Bus Backhaul',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.slateDark),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Leverage empty luggage bins in outstation buses and government runner pools',
                    style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                  ),
                ],
              ),
            ),
          ),

          // Options Grid
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
                itemCount: courierOptions.length,
                itemBuilder: (context, index) {
                  final item = courierOptions[index];
                  return _buildCourierCard(context, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourierCard(BuildContext context, CourierOption item) {
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTeal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.tierTag,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                  ),
                ),
                const SizedBox(height: 8),
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
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.formatInt(item.price),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryTeal),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.priceLabel,
                      style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => PaymentModal(
                        title: item.title,
                        amount: item.price,
                        vendorId: item.vendorId,
                        serviceType: 'errand_delivery',
                      ),
                    );
                  },
                  child: const Text('Book Parcel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
