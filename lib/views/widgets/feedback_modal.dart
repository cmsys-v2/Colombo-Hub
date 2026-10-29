import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_providers.dart';

class FeedbackModal extends ConsumerStatefulWidget {
  const FeedbackModal({super.key});

  @override
  ConsumerState<FeedbackModal> createState() => _FeedbackModalState();
}

class _FeedbackModalState extends ConsumerState<FeedbackModal> {
  final TextEditingController _feedbackController = TextEditingController();
  String _category = 'Bus Route Suggestion';

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_feedbackController.text.trim().isEmpty) return;

    ref.read(userProfileProvider.notifier).rewardScoutPoints(25);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted to ColomboHub Team! +25 Scout Points awarded 💡'),
        backgroundColor: AppTheme.slateDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.lightbulb, color: AppTheme.amberAccent, size: 20),
                      SizedBox(width: 8),
                      Text('Suggest Route / Feature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),
              const Text('Category:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                items: const [
                  DropdownMenuItem(value: 'Bus Route Suggestion', child: Text('Bus Route Suggestion')),
                  DropdownMenuItem(value: 'Lunch Pool Drop Location', child: Text('Lunch Pool Drop Location')),
                  DropdownMenuItem(value: 'Boarding Area Request', child: Text('Boarding Area Request')),
                  DropdownMenuItem(value: 'General App Feedback', child: Text('General App Feedback')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 12),
              const Text('Details & Waypoints:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Please add an early morning express shuttle from Kandy to Fort via Central Expressway...',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit (+25 Scout Pts)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
