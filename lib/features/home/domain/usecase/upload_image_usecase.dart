import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadImageUseCase implements Usecase<String, UploadImageParams> {
  final ChatRepository chatRepository;

  UploadImageUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return chatRepository.uploadImage(params.imagePath);
  }
}

class UploadImageParams {
  final String imagePath;

  UploadImageParams({required this.imagePath});
}

