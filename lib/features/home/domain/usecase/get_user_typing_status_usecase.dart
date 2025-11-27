import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/stream_usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserTypingStatusUseCase implements StreamUsecase<bool, GetUserTypingStatusParams> {
  final ChatRepository chatRepository;

  GetUserTypingStatusUseCase({required this.chatRepository});

  @override
  Stream<Either<Failure, bool>> call(GetUserTypingStatusParams params) {
    return chatRepository.getUserTypingStatus(
      userId: params.userId,
      currentUserId: params.currentUserId,
    );
  }
}

class GetUserTypingStatusParams {
  final String userId;
  final String currentUserId;

  GetUserTypingStatusParams({
    required this.userId,
    required this.currentUserId,
  });
}

