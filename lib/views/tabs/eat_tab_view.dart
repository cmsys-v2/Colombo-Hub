import 'package:flutter/material.dart';
import '../../features/lunch_pool/screens/lunch_pool_screen.dart';

export '../../features/lunch_pool/screens/lunch_pool_screen.dart';

class EatTabView extends StatelessWidget {
  const EatTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LunchPoolScreen();
  }
}
