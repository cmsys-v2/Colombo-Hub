import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/service_provider_model.dart';
import '../../../state/app_providers.dart';

/// ColomboHub Chat & Community Commuter Lounge Screen
/// Real-time commuter messaging, instant ColomboHub Assistant responses,
/// and official Meta WhatsApp Business Cloud API deep-linking.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
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
                      style: TextStyle(fontSize: 10, color: AppTheme.darkTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.send, size: 12),
                label: const Text('Open WhatsApp', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.emeraldGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onPressed: _openWhatsApp,
              ),
            ],
          ),
        ),

        // Quick Suggestion Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              _buildPromptChip('Form-C Annex in Rajagiriya?'),
              const SizedBox(width: 8),
              _buildPromptChip('Kandy-Colombo E04 bus timings?'),
              const SizedBox(width: 8),
              _buildPromptChip('Is WTC lunch pool open?'),
              const SizedBox(width: 8),
              _buildPromptChip('Report Litro Gas depot stock (+15 pts)'),
            ],
          ),
        ),

        // Chat Message Stream
        Expanded(
          child: Card(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Message Input Row
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.slateBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    hintText: 'Ask ColomboHub Assistant or query community...',
                    hintStyle: TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.sendHorizontal, color: AppTheme.primaryTeal),
                onPressed: _send,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromptChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.darkTeal)),
      backgroundColor: AppTheme.lightTeal,
      side: const BorderSide(color: AppTheme.tealBorder),
      onPressed: () {
        _msgController.text = label;
        _send();
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isAssistant ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isAssistant ? AppTheme.slateLightBg : AppTheme.primaryTeal,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(msg.isAssistant ? 0 : 14),
            bottomRight: Radius.circular(msg.isAssistant ? 14 : 0),
          ),
          border: Border.all(
            color: msg.isAssistant ? AppTheme.slateBorder : AppTheme.darkTeal,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.senderName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: msg.isAssistant ? AppTheme.darkTeal : Colors.white70,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 9,
                    color: msg.isAssistant ? AppTheme.slateMuted : Colors.white60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 12,
                color: msg.isAssistant ? AppTheme.slateDark : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
