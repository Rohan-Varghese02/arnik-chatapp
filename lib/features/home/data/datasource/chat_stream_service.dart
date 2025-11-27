import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatStreamService {
  final ChatRepository chatRepository;

  ChatStreamService({required this.chatRepository});

  Stream<bool> getOnlineStatusStream(String userId) {
    return chatRepository.getUserOnlineStatus(userId).map(
      (either) => either.fold((failure) => false, (isOnline) => isOnline),
    );
  }

  Stream<bool> getTypingStatusStream({
    required String userId,
    required String currentUserId,
  }) {
    return chatRepository.getUserTypingStatus(
      userId: userId,
      currentUserId: currentUserId,
    ).map(
      (either) => either.fold((failure) => false, (isTyping) => isTyping),
    );
  }

  Stream<Either<Failure, List<MessageEntity>>> getMessagesStream({
    required String senderUid,
    required String receiverUid,
  }) {
    return chatRepository.getMessages(
      senderUid: senderUid,
      receiverUid: receiverUid,
    );
  }
}

