import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/data/datasource/chat_remote_datasource.dart';
import 'package:chat_app/features/home/domain/entities/chat_entity.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;

  ChatRepositoryImpl({required this.chatRemoteDatasource});

  @override
  Stream<Either<Failure, List<ChatEntity>>> getChats() {
    try {
      return chatRemoteDatasource.getChats().map<Either<Failure, List<ChatEntity>>>((chats) {
        return Right(chats.map((model) => model as ChatEntity).toList());
      }).handleError((error) {
        return Left<Failure, List<ChatEntity>>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left<Failure, List<ChatEntity>>(ServerFailure(e.toString())));
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> getMessages({
    required String senderUid,
    required String receiverUid,
  }) {
    try {
      return chatRemoteDatasource.getMessages(
        senderUid: senderUid,
        receiverUid: receiverUid,
      ).map<Either<Failure, List<MessageEntity>>>((messages) {
        return Right(messages.map((model) => model as MessageEntity).toList());
      }).handleError((error) {
        return Left<Failure, List<MessageEntity>>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left<Failure, List<MessageEntity>>(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String senderID,
    required String receiverID,
    required String message,
    String? imageUrl,
  }) async {
    try {
      await chatRemoteDatasource.sendMessage(
        senderID: senderID,
        receiverID: receiverID,
        message: message,
        imageUrl: imageUrl,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String imagePath) async {
    try {
      final imageUrl = await chatRemoteDatasource.uploadImageToCloudinary(imagePath);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, bool>> getUserOnlineStatus(String userId) {
    try {
      return chatRemoteDatasource.getUserOnlineStatus(userId).map<Either<Failure, bool>>((isOnline) {
        return Right(isOnline);
      }).handleError((error) {
        return Left<Failure, bool>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left<Failure, bool>(ServerFailure(e.toString())));
    }
  }

  @override
  Stream<Either<Failure, bool>> getUserTypingStatus({
    required String userId,
    required String currentUserId,
  }) {
    try {
      return chatRemoteDatasource.getUserTypingStatus(
        userId: userId,
        currentUserId: currentUserId,
      ).map<Either<Failure, bool>>((isTyping) {
        return Right(isTyping);
      }).handleError((error) {
        return Left<Failure, bool>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left<Failure, bool>(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> setUserOnlineStatus(bool isOnline) async {
    try {
      await chatRemoteDatasource.setUserOnlineStatus(isOnline);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTypingStatus({
    required String receiverId,
    required bool isTyping,
  }) async {
    try {
      await chatRemoteDatasource.setTypingStatus(
        receiverId: receiverId,
        isTyping: isTyping,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

