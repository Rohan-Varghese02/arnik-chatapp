import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUseCase implements Usecase<void, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessageUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) {
    return chatRepository.sendMessage(
      senderID: params.senderID,
      receiverID: params.receiverID,
      message: params.message,
      imageUrl: params.imageUrl,
    );
  }
}

class SendMessageParams {
  final String senderID;
  final String receiverID;
  final String message;
  final String? imageUrl;

  SendMessageParams({
    required this.senderID,
    required this.receiverID,
    required this.message,
    this.imageUrl,
  });
}

