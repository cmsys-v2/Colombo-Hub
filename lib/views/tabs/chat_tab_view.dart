import 'package:flutter/material.dart';
import '../../features/chat/screens/chat_screen.dart';

export '../../features/chat/screens/chat_screen.dart';

class ChatTabView extends StatelessWidget {
  const ChatTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}
