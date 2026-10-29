import 'package:flutter/material.dart';
import '../../features/transport/screens/transport_screen.dart';

export '../../features/transport/screens/transport_screen.dart';

class MoveTabView extends StatelessWidget {
  const MoveTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransportScreen();
  }
}
