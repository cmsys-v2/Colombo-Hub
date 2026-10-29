import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/transport_model.dart';
import '../../../state/app_providers.dart';
import '../../../views/widgets/payment_modal.dart';

/// ColomboHub Transport Screen
/// Displays the 6 major Sri Lankan Expressway commuter corridors
/// (Kandy-Colombo E04, Galle-Makumbura E01, Katunayake-Fort E03, Kadawatha, Negombo, Panadura)
/// with live seat reservations, monthly commuter pass discounts, and relocation savings calculator.
class TransportScreen extends ConsumerWidget {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(busRoutesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commute vs Relocation Calculator Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.slateDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 650;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: isWide ? 2 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.amberAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Commute vs Relocation Cost Calculator',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Highway Express Pass vs. Colombo Annex Rent',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Average Colombo Boarding: ~Rs. 38,000/mo • Highway AC Bus Pass: ~Rs. 15,800/mo',
                            style: TextStyle(fontSize: 11, color: AppTheme.slateBorder),
                          ),
                        ],
                      ),
                    ),
                    if (!isWide) const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF134E4A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2DD4BF).withValues(alpha: 0.4)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Net Estimated Monthly Savings',
                            style: TextStyle(fontSize: 11, color: Color(0xFFCCFBF1)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '💰 Rs. 22,200 / mo',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFFDE047)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              '6 Official Expressway Express Corridors',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
            ),
          ),

          // Routes Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 580 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 275,
                ),
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final item = routes[index];
                  return _buildRouteCard(context, ref, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, WidgetRef ref, TransportModel item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: AppTheme.slateLightBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.slateDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.expresswayTag,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.seatsLeft <= 5 ? const Color(0xFFFEF2F2) : AppTheme.emeraldLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: item.seatsLeft <= 5 ? const Color(0xFFFECACA) : AppTheme.emeraldBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.users,
                        size: 11,
                        color: item.seatsLeft <= 5 ? Colors.red : AppTheme.emeraldGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.seatsLeft} Seats Left',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.seatsLeft <= 5 ? Colors.red : AppTheme.emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.slateDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.busType,
                    style: const TextStyle(fontSize: 11, color: AppTheme.primaryTeal, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 12, color: AppTheme.slateMuted),
                      const SizedBox(width: 4),
                      Text(
                        'Departs: ${item.departureTime} • ETA: ${item.arrivalTime}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.gitFork, size: 12, color: AppTheme.slateMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.waypoints,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Fares & Actions
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
                                CurrencyFormatter.formatLkr(item.dailyPrice),
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.darkTeal),
                              ),
                              const Text(' /day', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                            ],
                          ),
                          Text(
                            'Pass: ${CurrencyFormatter.formatLkr(item.monthlyPassPrice)}/mo (-25%)',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              minimumSize: const Size(50, 30),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => PaymentModal(
                                  title: 'Monthly Pass: ${item.corridorName}',
                                  amount: item.monthlyPassPrice,
                                  vendorId: item.vendorId,
                                ),
                              );
                            },
                            child: const Text('Pass', style: TextStyle(fontSize: 11)),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(60, 30),
                            ),
                            onPressed: item.seatsLeft > 0
                                ? () {
                                    ref.read(busRoutesProvider.notifier).bookSeat(item.id);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => PaymentModal(
                                        title: 'Seat Booking: ${item.corridorName}',
                                        amount: item.dailyPrice,
                                        vendorId: item.vendorId,
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              item.seatsLeft > 0 ? 'Book' : 'Full',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
