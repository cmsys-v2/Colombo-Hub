import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CourierScreen extends StatelessWidget {
  const CourierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('📦 Connected Courier & Bus Parcel Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF0F766E), child: Icon(LucideIcons.bus, color: Colors.white)),
            title: const Text('Hometown Staff Bus Parcel Backhaul'),
            subtitle: const Text('Kurunegala (5:40 AM) ➔ Colombo Fort (7:25 AM)\nNC-4829 • Up to 5kg'),
            trailing: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bus Luggage Slot Reserved (Rs. 250)!')));
              },
              child: const Text('Rs. 250'),
            ),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Icon(LucideIcons.bike, color: Colors.white)),
            title: const Text('Corporate & Gov Document Loop Runner'),
            subtitle: const Text('10 AM / 2 PM batch drops: WTC, Ministries & Embassies'),
            trailing: FilledButton.tonal(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document Runner Booked (Rs. 180)!')));
              },
              child: const Text('Rs. 180'),
            ),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}
