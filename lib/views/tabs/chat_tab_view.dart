import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/other_models.dart';
import '../../state/app_providers.dart';

class ChatTabView extends ConsumerStatefulWidget {
  const ChatTabView({super.key});

  @override
  ConsumerState<ChatTabView> createState() => _ChatTabViewState();
}

class _ChatTabViewState extends ConsumerState<ChatTabView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _msgController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openWhatsApp() async {
    const text = 'Hello ColomboHub! Need assistance with my highway bus booking and lunch pool.';
    final uri = Uri.parse('https://wa.me/${AppConstants.supportWhatsAppNumber}?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp app')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Column(
      children: [
        // Meta WhatsApp Cloud API Active Banner
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.emeraldLight,
            border: Border.all(color: AppTheme.emeraldBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.messageCircle, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Meta WhatsApp Business Cloud API Bridge Active',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Webhook connected to Firebase Cloud Functions for automatic dispatch & bus notifications.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF047857)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Messages Box
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.slateLightBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.slateBorder),
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Input row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgController,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Type inquiry, bus schedule, or polos lunch question...',
                  hintStyle: const TextStyle(fontSize: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(LucideIcons.send, color: AppTheme.primaryTeal, size: 18),
                    onPressed: _send,
                  ),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _openWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.emeraldGreen,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              icon: const Icon(LucideIcons.messageSquare, size: 16),
              label: const Text('WhatsApp Bot', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = !msg.isAssistant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppTheme.primaryTeal,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('CH', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryTeal : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: isUser ? null : Border.all(color: AppTheme.slateBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      msg.senderName,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                    ),
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? Colors.white : AppTheme.slateDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppTheme.slateMuted,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
