import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/presentation/widgets/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class MessagesStreamBuilder extends StatelessWidget {
  final Stream<Either<Failure, List<MessageEntity>>> messagesStream;
  final String currentUserId;
  final ScrollController scrollController;

  const MessagesStreamBuilder({
    super.key,
    required this.messagesStream,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading messages',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade700,
            ),
          );
        }
        return snapshot.data?.fold(
              (failure) => Center(
                child: Text(
                  failure.message,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
              (messages) => MessagesList(
                messages: messages,
                currentUserId: currentUserId,
                scrollController: scrollController,
              ),
            ) ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}

