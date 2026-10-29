import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('💬 In-App Realtime Firestore Chat & WhatsApp Bot Sync Active',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
