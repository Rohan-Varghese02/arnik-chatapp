import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/stream_usecase.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/entities/chat_entity.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChatsUseCase implements StreamUsecase<List<ChatEntity>, NoParams> {
  final ChatRepository chatRepository;

  GetChatsUseCase({required this.chatRepository});

  @override
  Stream<Either<Failure, List<ChatEntity>>> call(NoParams params) {
    return chatRepository.getChats();
  }
}


