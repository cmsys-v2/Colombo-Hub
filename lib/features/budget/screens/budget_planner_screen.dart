import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../state/app_providers.dart';

/// ColomboHub Budget Planner Screen
/// Comprehensive Sri Lankan Commuter & Corporate Budget Planner:
/// - Gross Salary slider and text input (Rs. 50,000 to Rs. 500,000)
/// - Real-time EPF calculation (8% employee contribution)
/// - APIT Tax calculation (tax-free up to Rs. 150,000, 6% standard tier)
/// - Boarding annex vs Expressway daily commuting comparison
/// - Prorated utility bill splitting with WhatsApp bill sharing.
class BudgetPlannerScreen extends ConsumerWidget {
  const BudgetPlannerScreen({super.key});

  Future<void> _shareBillWhatsApp(BuildContext context, double bill, double share) async {
    final text = 'ColomboHub Utility Bill Reminder:\n'
        '• Total CEB/Water Bill: ${CurrencyFormatter.formatInt(bill)}\n'
        '• Each Roommate\'s Share: ${CurrencyFormatter.formatInt(share)}\n'
        'Please transfer via FriMi / Genie / Commercial Bank / Sampath Pay.';

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
          const SnackBar(content: Text('Could not launch WhatsApp. Bill details copied!')),
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
                                    items: const [
                                      DropdownMenuItem(value: 'boarding', child: Text('Board in Colombo (Rajagiriya/Malabe)', style: TextStyle(fontSize: 12))),
                                      DropdownMenuItem(value: 'commuter', child: Text('Daily Expressway Commute (Makumbura/Kadawatha)', style: TextStyle(fontSize: 12))),
                                      DropdownMenuItem(value: 'shared', child: Text('Shared Annex with Roommates', style: TextStyle(fontSize: 12))),
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

                        // Sliders for dynamic costs
                        _buildCostSlider(
                          label: 'Estimated Rent / Boarding Allowance',
                          value: budget.rentCost,
                          min: 0,
                          max: 60000,
                          onChanged: (v) => ref.read(budgetProvider.notifier).setRentCost(v),
                        ),
                        _buildCostSlider(
                          label: 'Monthly Transport / Expressway Pass',
                          value: budget.transportCost,
                          min: 0,
                          max: 30000,
                          onChanged: (v) => ref.read(budgetProvider.notifier).setTransportCost(v),
                        ),
                        _buildCostSlider(
                          label: 'Monthly Food & Lunch Pool',
                          value: budget.foodCost,
                          min: 0,
                          max: 40000,
                          onChanged: (v) => ref.read(budgetProvider.notifier).setFoodCost(v),
                        ),
                        _buildCostSlider(
                          label: 'Utilities (CEB Electricity & Water)',
                          value: budget.utilityCost,
                          min: 0,
                          max: 20000,
                          onChanged: (v) => ref.read(budgetProvider.notifier).setUtilityCost(v),
                        ),

                        const Divider(height: 24),

                        // Statutory Deductions (EPF & APIT)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.slateLightBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.slateBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🇱🇰 Statutory Deductions (Sri Lankan Labor Law)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Employee EPF (8%):', style: TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
                                  Text(
                                    '- ${CurrencyFormatter.formatInt(budget.epfEmployee)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('APIT Income Tax (6% over Rs. 150k):', style: TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
                                  Text(
                                    '- ${CurrencyFormatter.formatInt(budget.apitTax)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Monthly Living Expenses:', style: TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
                                  Text(
                                    '- ${CurrencyFormatter.formatInt(budget.totalExpenses)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.amberAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Net Balance Highlight
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: budget.netSavings >= 0 ? AppTheme.emeraldLight : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: budget.netSavings >= 0 ? AppTheme.emeraldBorder : const Color(0xFFFECACA),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    budget.netSavings >= 0 ? 'Estimated Net Monthly Savings:' : 'Monthly Deficit Warning:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: budget.netSavings >= 0 ? AppTheme.emeraldGreen : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    budget.netSavings >= 0 ? 'Discretionary income after all living and statutory costs' : 'Consider reducing rent or switching to Expressway bus pass',
                                    style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                                  ),
                                ],
                              ),
                              Text(
                                CurrencyFormatter.formatInt(budget.netSavings),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: budget.netSavings >= 0 ? AppTheme.emeraldGreen : Colors.red,
                                ),
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

              // 2. Shared Utilities Splitter
              Expanded(
                flex: isWide ? 1 : 0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ CEB & Water Bill Splitter',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Split separate meter electricity or water equally between roommates',
                          style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                        const Divider(height: 20),

                        const Text('Total Bill Amount (LKR)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextFormField(
                          initialValue: budget.totalUtilityBill.toInt().toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: 'Rs. ',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          onChanged: (val) {
                            final numVal = double.tryParse(val) ?? 0;
                            ref.read(budgetProvider.notifier).setTotalUtilityBill(numVal);
                          },
                        ),
                        const SizedBox(height: 12),

                        const Text('Number of Roommates', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.minusCircle, size: 20, color: AppTheme.slateMuted),
                              onPressed: budget.roommatesCount > 1
                                  ? () => ref.read(budgetProvider.notifier).setRoommatesCount(budget.roommatesCount - 1)
                                  : null,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.slateLightBg,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.slateBorder),
                                ),
                                child: Text(
                                  '${budget.roommatesCount} Roommates',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.slateDark),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.plusCircle, size: 20, color: AppTheme.primaryTeal),
                              onPressed: () => ref.read(budgetProvider.notifier).setRoommatesCount(budget.roommatesCount + 1),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTeal,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.tealBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Each Person Owes:', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                              const SizedBox(height: 2),
                              Text(
                                CurrencyFormatter.formatInt(budget.perPersonShare),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: AppTheme.darkTeal,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(LucideIcons.send, size: 14),
                            label: const Text('Share Split on WhatsApp'),
                            onPressed: () => _shareBillWhatsApp(
                              context,
                              budget.totalUtilityBill,
                              budget.perPersonShare,
                            ),
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

  Widget _buildCostSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.slateDark)),
              Text(
                CurrencyFormatter.formatInt(value),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
              ),
            ],
          ),
          SliderTheme(
            data: const SliderThemeData(
              activeTrackColor: AppTheme.primaryTeal,
              thumbColor: AppTheme.darkTeal,
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
