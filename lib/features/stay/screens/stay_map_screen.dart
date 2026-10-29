import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../shell/screens/main_shell_screen.dart';

class StayMapScreen extends ConsumerWidget {
  const StayMapScreen({super.key});

  Future<void> _handleScoutUpload(BuildContext context, WidgetRef ref, double lat, double lng) async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      
      Position pos = await Geolocator.getCurrentPosition();
      double distMeters = Geolocator.distanceBetween(pos.latitude, pos.longitude, lat, lng);

      if (distMeters <= 60.0) {
        ref.read(userScoutPointsProvider.notifier).state += 50;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ GPS Verified within 60m! Photo uploaded. +50 Scout Points added!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('📍 Verification failed: You are ${distMeters.toInt()}m away (must be within 60m).')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Workplace Commute Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: 'WTC',
                  decoration: const InputDecoration(
                    prefixIcon: Icon(LucideIcons.building2),
                    labelText: 'Office Destination',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'WTC', child: Text('World Trade Center (Colombo 01)')),
                    DropdownMenuItem(value: 'Bamba', child: Text('Bambalapitiya / Col 04')),
                    DropdownMenuItem(value: 'Seth', child: Text('Sethsiripaya (Battaramulla)')),
                  ],
                  onChanged: (v) {},
                ),
                const SizedBox(height: 12),
                const Text('Max Rush-Hour Commute: 25 mins', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Slider(value: 25, min: 10, max: 60, onChanged: (v) {}, activeColor: const Color(0xFF0F766E)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Listing Card with Scout Points Verification
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                color: const Color(0xFFCCFBF1),
                child: const Center(
                  child: Text('📷 [ 6 Landlord Photos • 9 Verified Scout Photos ]',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Modern Annex — Rajagiriya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Rs. 32,000/mo', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.teal.shade800)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('⏱️ 18 mins to WTC • Daily: Rs. 2,800 • Form-C Police Registration Ready', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                      onPressed: () => _handleScoutUpload(context, ref, 6.9061, 79.8997),
                      icon: const Icon(LucideIcons.camera, size: 16),
                      label: const Text('I Visited: Upload Real Photo (+50 Pts)'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
