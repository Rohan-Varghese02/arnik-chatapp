import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetUserOnlineStatusUseCase implements Usecase<void, SetUserOnlineStatusParams> {
  final ChatRepository chatRepository;

  SetUserOnlineStatusUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, void>> call(SetUserOnlineStatusParams params) {
    return chatRepository.setUserOnlineStatus(params.isOnline);
  }
}

class SetUserOnlineStatusParams {
  final bool isOnline;

  SetUserOnlineStatusParams({required this.isOnline});
}

