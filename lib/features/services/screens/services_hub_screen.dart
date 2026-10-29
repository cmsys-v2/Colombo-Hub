import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ServicesHubScreen extends StatelessWidget {
  const ServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('🛠️ Household, Boarding & Office Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: Icon(LucideIcons.shirt, color: Color(0xFF0F766E)),
            title: Text('Office Lobby Laundry & 5-Shirt Ironing'),
            subtitle: Text('Drop off Mon morning in lobby; returned Wed noon crisp.'),
            trailing: Text('Rs. 450', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(LucideIcons.carrot, color: Colors.orange),
            title: Text('6 PM Transit Hub Cut-Veg Pack'),
            subtitle: Text('Pre-ordered chopped curry packs at Fort / Makumbura hubs.'),
            trailing: Text('Rs. 790', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(LucideIcons.wrench, color: Colors.purple),
            title: Text('Weekend Pooled AC / Plumbing Repair'),
            subtitle: Text('25% off when 3+ households in same zone book for Saturday.'),
            trailing: Text('Rs. 3,200', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
