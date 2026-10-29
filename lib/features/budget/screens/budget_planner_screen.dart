import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BudgetState {
  final double salary;
  final double rentAndBills;
  final double commute;
  final double food;
  final double householdServices;
  final double utilityBill;
  final int roommates;

  BudgetState({
    this.salary = 145000,
    this.rentAndBills = 32000,
    this.commute = 6500,
    this.food = 28000,
    this.householdServices = 9500,
    this.utilityBill = 8400,
    this.roommates = 3,
  });

  double get totalExpense => rentAndBills + commute + food + householdServices;
  double get poolSavings => 8450; // Saved via Lunch Pools, Bus Parcels, Pooled Repairs
  double get netSavings => salary - totalExpense + poolSavings;
  double get splitShare => utilityBill / (roommates > 0 ? roommates : 1);
}

final budgetProvider = StateProvider<BudgetState>((ref) => BudgetState());

class BudgetPlannerScreen extends ConsumerWidget {
  const BudgetPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = ref.watch(budgetProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF0F172A),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Work-Living Financial Overview', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text('Take-Home Net Savings: Rs. ${b.netSavings.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFF34D399), fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Expenses: Rs. ${b.totalExpense.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('Pool Savings: +Rs. ${b.poolSavings.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚡ Shared Annex Bill Splitter (Prorated)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                Text('Total CEB & Water Bill: Rs. ${b.utilityBill.toStringAsFixed(0)}'),
                Text('Each Roommate (${b.roommates} persons) pays: Rs. ${b.splitShare.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment requests dispatched via WhatsApp!')),
                    );
                  },
                  icon: const Icon(LucideIcons.share2, size: 16),
                  label: const Text('Send WhatsApp Split Request'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
