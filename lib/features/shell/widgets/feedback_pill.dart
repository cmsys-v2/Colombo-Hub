import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../views/widgets/feedback_modal.dart';

/// ColomboHub Floating Feedback Pill Widget
/// Provides commuters and partners with a one-click channel to submit
/// feature requests, Form-C property reports, or scout corrections.
class FeedbackPill extends StatefulWidget {
  final VoidCallback? onCustomTap;

  const FeedbackPill({super.key, this.onCustomTap});

  @override
  State<FeedbackPill> createState() => _FeedbackPillState();
}

class _FeedbackPillState extends State<FeedbackPill> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onCustomTap != null) {
      widget.onCustomTap!();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => const FeedbackModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.slateDark, Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppTheme.primaryTeal.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: _isHovered ? 14 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _isHovered ? AppTheme.primaryTeal : const Color(0xFF334155),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.messageSquare,
                      size: 14,
                      color: AppTheme.tealBorder,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Feedback / Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppTheme.amberAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '+25 pts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
