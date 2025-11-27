import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/stream_usecase.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMessagesUseCase implements StreamUsecase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository chatRepository;

  GetMessagesUseCase({required this.chatRepository});

  @override
  Stream<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return chatRepository.getMessages(
      senderUid: params.senderUid,
      receiverUid: params.receiverUid,
    );
  }
}

class GetMessagesParams {
  final String senderUid;
  final String receiverUid;

  GetMessagesParams({
    required this.senderUid,
    required this.receiverUid,
  });
}

