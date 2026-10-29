import 'package:flutter/material.dart';
import '../../features/budget/screens/budget_planner_screen.dart';

export '../../features/budget/screens/budget_planner_screen.dart';

class BudgetTabView extends StatelessWidget {
  const BudgetTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetPlannerScreen();
  }
}
