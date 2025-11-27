import 'dart:async';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/domain/usecase/send_message_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/set_typing_status_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/upload_image_usecase.dart';
import 'package:fpdart/fpdart.dart';

class ChatService {
  final SendMessageUseCase sendMessageUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final SetTypingStatusUseCase setTypingStatusUseCase;

  Timer? _typingTimer;

  ChatService({
    required this.sendMessageUseCase,
    required this.uploadImageUseCase,
    required this.setTypingStatusUseCase,
  });

  void handleTextChanged({
    required String text,
    required String receiverId,
  }) {
    if (text.isNotEmpty) {
      setTypingStatusUseCase.call(
        SetTypingStatusParams(receiverId: receiverId, isTyping: true),
      );
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        setTypingStatusUseCase.call(
          SetTypingStatusParams(receiverId: receiverId, isTyping: false),
        );
      });
    } else {
      setTypingStatusUseCase.call(
        SetTypingStatusParams(receiverId: receiverId, isTyping: false),
      );
      _typingTimer?.cancel();
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    setTypingStatusUseCase.call(
      SetTypingStatusParams(receiverId: receiverId, isTyping: false),
    );
    _typingTimer?.cancel();

    await sendMessageUseCase.call(
      SendMessageParams(
        senderID: senderId,
        receiverID: receiverId,
        message: message,
      ),
    );
  }

  Future<Either<Failure, void>> uploadAndSendImage({
    required String imagePath,
    required String senderId,
    required String receiverId,
  }) async {
    final uploadResult = await uploadImageUseCase.call(
      UploadImageParams(imagePath: imagePath),
    );

    return uploadResult.fold(
      (failure) => Left(failure),
      (imageUrl) async {
        final sendResult = await sendMessageUseCase.call(
          SendMessageParams(
            senderID: senderId,
            receiverID: receiverId,
            message: '📷 Photo',
            imageUrl: imageUrl,
          ),
        );
        return sendResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      },
    );
  }

  void stopTyping(String receiverId) {
    setTypingStatusUseCase.call(
      SetTypingStatusParams(receiverId: receiverId, isTyping: false),
    );
    _typingTimer?.cancel();
  }

  void dispose() {
    _typingTimer?.cancel();
  }
}

