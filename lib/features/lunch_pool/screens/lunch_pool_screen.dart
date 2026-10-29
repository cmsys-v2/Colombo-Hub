import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final poolCountProvider = StateProvider<int>((ref) => 42);

class LunchPoolScreen extends ConsumerWidget {
  const LunchPoolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(poolCountProvider);
    final courierFee = (600 / count).ceil();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🍱 WTC Office Building Lunch Pool', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('10:30 AM Cutoff • Single courier batch drop at 12:15 PM Lobby', style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFF0FDF4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🔥 $count Colleagues Joined Today', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                  Text('Courier Fee: Rs. $courierFee / person', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF166534))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
            onPressed: () {
              ref.read(poolCountProvider.notifier).state++;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Joined today\'s lunch pool! Courier fee reduced.')),
              );
            },
            child: const Text('+ Join Today\'s Red Rice Home-Chef Pool (Rs. 480)'),
          ),
        ],
      ),
    );
  }
}
