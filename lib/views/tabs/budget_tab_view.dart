import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../state/app_providers.dart';

class BudgetTabView extends ConsumerWidget {
  const BudgetTabView({super.key});

  Future<void> _shareBillWhatsApp(BuildContext context, double bill, double share) async {
    final text = 'ColomboHub Utility Reminder:\n'
        'Total Bill: ${CurrencyFormatter.formatInt(bill)}\n'
        'Each Roommate\'s Share: ${CurrencyFormatter.formatInt(share)}\n'
        'Please transfer via FriMi / Genie / Commercial Bank.';

    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp. Bill text copied!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 850;
          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Monthly Budget Planner
              Expanded(
                flex: isWide ? 2 : 0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 Smart Commuter vs. Boarding Budget Advisor',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Calculate true net take-home salary after deducting rent, transport, food, utilities & tax',
                          style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                        const Divider(height: 24),

                        // Inputs
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Gross Monthly Salary (LKR)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    initialValue: budget.salary.toInt().toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      prefixText: 'Rs. ',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    ),
                                    onChanged: (val) {
                                      final numVal = double.tryParse(val) ?? 0;
                                      ref.read(budgetProvider.notifier).setSalary(numVal);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Stay Strategy', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  DropdownButtonFormField<String>(
                                    initialValue: budget.strategy,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    ),
                                    style: const TextStyle(fontSize: 11, color: AppTheme.slateDark),
                                    items: const [
                                      DropdownMenuItem(value: 'boarding', child: Text('Boarding Annex (Rs. 32k/mo)')),
                                      DropdownMenuItem(value: 'commuter', child: Text('Daily Highway Bus Commute')),
                                      DropdownMenuItem(value: 'shared', child: Text('Shared Annex with 2 Roommates')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        ref.read(budgetProvider.notifier).setStrategy(val);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Deduction Grid
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.slateLightBg,
                            border: Border.all(color: AppTheme.slateBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 2.4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              _buildCostTile('Accommodation', CurrencyFormatter.formatInt(budget.rent)),
                              _buildCostTile('Monthly Transport', CurrencyFormatter.formatInt(budget.transport)),
                              _buildCostTile('Lunch Pool (22 Days)', CurrencyFormatter.formatInt(budget.food)),
                              _buildCostTile('APIT Tax & EPF (8%)', CurrencyFormatter.formatInt(budget.epf + budget.tax)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Net Take-Home Highlight
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTeal,
                            border: Border.all(color: AppTheme.tealBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estimated Net Take-Home & Disposable Savings',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    CurrencyFormatter.format(budget.netTakeHome),
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.darkTeal),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Budget projection saved to profile!'),
                                      backgroundColor: AppTheme.primaryTeal,
                                    ),
                                  );
                                },
                                child: const Text('Save Plan'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),

              // 2. Shared Annex Bill Splitter
              Expanded(
                flex: isWide ? 1 : 0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ Shared Annex Bill Splitter',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Prorated utility cost split by days stayed',
                          style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                        const Divider(height: 24),

                        const Text('Total CEB + Water + Fiber Bill (Rs.)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextFormField(
                          initialValue: budget.utilityBill.toInt().toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: 'Rs. ',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          onChanged: (val) {
                            final numVal = double.tryParse(val) ?? 0;
                            ref.read(budgetProvider.notifier).setUtilityBill(numVal);
                          },
                        ),
                        const SizedBox(height: 12),

                        const Text('Number of Roommates', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextFormField(
                          initialValue: budget.roommates.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          onChanged: (val) {
                            final numVal = int.tryParse(val) ?? 1;
                            ref.read(budgetProvider.notifier).setRoommates(numVal > 0 ? numVal : 1);
                          },
                        ),
                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.slateLightBg,
                            border: Border.all(color: AppTheme.slateBorder),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text('Each Roommate\'s Fair Share', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.formatInt(budget.splitShare),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.slateDark),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _shareBillWhatsApp(context, budget.utilityBill, budget.splitShare),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emeraldGreen),
                            icon: const Icon(LucideIcons.messageCircle, size: 16),
                            label: const Text('Send WhatsApp Reminder'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCostTile(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
        const SizedBox(height: 2),
        Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
      ],
    );
  }
}
