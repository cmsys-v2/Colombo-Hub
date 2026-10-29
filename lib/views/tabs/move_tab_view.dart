import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/bus_route.dart';
import '../../state/app_providers.dart';
import '../widgets/payment_modal.dart';

class MoveTabView extends ConsumerWidget {
  const MoveTabView({super.key});

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

          // Express Corridors Grid
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
                  mainAxisExtent: 260,
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

  Widget _buildRouteCard(BuildContext context, WidgetRef ref, BusRoute item) {
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTeal,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.expresswayTag,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.seatsLeft <= 3 ? const Color(0xFFFEF2F2) : AppTheme.emeraldLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.seatsLeft} Seats Left',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.seatsLeft <= 3 ? const Color(0xFFB91C1C) : AppTheme.emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.slateDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.busType} • Dep: ${item.departureTime} | Arr: ${item.arrivalTime}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  'Waypoints: ${item.waypoints}',
                  style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              children: [
                const Divider(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${CurrencyFormatter.formatInt(item.dailyPrice)}/day',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.primaryTeal),
                        ),
                        Text(
                          'Pass: ${CurrencyFormatter.formatInt(item.monthlyPassPrice)}/mo',
                          style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: item.seatsLeft > 0
                              ? () {
                                  ref.read(busRoutesProvider.notifier).bookDailySeat(item.id);
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PaymentModal(
                                      title: '${item.title} (Daily Seat)',
                                      amount: item.dailyPrice,
                                      vendorId: item.vendorId,
                                      serviceType: 'transport_seat',
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            backgroundColor: AppTheme.primaryTeal,
                          ),
                          child: const Text('Daily Seat', style: TextStyle(fontSize: 10)),
                        ),
                        const SizedBox(width: 4),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => PaymentModal(
                                title: '${item.title} (Monthly Pass)',
                                amount: item.monthlyPassPrice,
                                vendorId: item.vendorId,
                                serviceType: 'transport_pass',
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            backgroundColor: AppTheme.slateDark,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Pass', style: TextStyle(fontSize: 10)),
                        ),
                      ],
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
