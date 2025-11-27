import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetTypingStatusUseCase implements Usecase<void, SetTypingStatusParams> {
  final ChatRepository chatRepository;

  SetTypingStatusUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, void>> call(SetTypingStatusParams params) {
    return chatRepository.setTypingStatus(
      receiverId: params.receiverId,
      isTyping: params.isTyping,
    );
  }
}

class SetTypingStatusParams {
  final String receiverId;
  final bool isTyping;

  SetTypingStatusParams({
    required this.receiverId,
    required this.isTyping,
  });
}

