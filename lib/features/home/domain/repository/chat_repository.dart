import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/domain/entities/chat_entity.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatEntity>>> getChats();
  Stream<Either<Failure, List<MessageEntity>>> getMessages({
    required String senderUid,
    required String receiverUid,
  });
  Future<Either<Failure, void>> sendMessage({
    required String senderID,
    required String receiverID,
    required String message,
    String? imageUrl,
  });
  Future<Either<Failure, String>> uploadImage(String imagePath);
  Stream<Either<Failure, bool>> getUserOnlineStatus(String userId);
  Stream<Either<Failure, bool>> getUserTypingStatus({
    required String userId,
    required String currentUserId,
  });
  Future<Either<Failure, void>> setUserOnlineStatus(bool isOnline);
  Future<Either<Failure, void>> setTypingStatus({
    required String receiverId,
    required bool isTyping,
  });
}

