import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  final List<MessageEntity> messages;
  final String currentUserId;
  final ScrollController scrollController;

  const MessagesList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'Tap to start chatting',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.senderID == currentUserId;
        return ChatBubble(
          message: message.message,
          timestamp: message.timestamp,
          isCurrentUser: isCurrentUser,
          imageUrl: message.imageUrl,
        );
      },
    );
  }
}

