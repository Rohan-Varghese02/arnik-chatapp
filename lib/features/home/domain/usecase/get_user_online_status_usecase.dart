import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/stream_usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserOnlineStatusUseCase implements StreamUsecase<bool, GetUserOnlineStatusParams> {
  final ChatRepository chatRepository;

  GetUserOnlineStatusUseCase({required this.chatRepository});

  @override
  Stream<Either<Failure, bool>> call(GetUserOnlineStatusParams params) {
    return chatRepository.getUserOnlineStatus(params.userId);
  }
}

class GetUserOnlineStatusParams {
  final String userId;

  GetUserOnlineStatusParams({required this.userId});
}

