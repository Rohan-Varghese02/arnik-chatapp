import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_chats_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_messages_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/send_message_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/upload_image_usecase.dart';
import 'package:chat_app/features/home/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/home/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final UploadImageUseCase uploadImageUseCase;

  StreamSubscription? _chatsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.getChatsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.uploadImageUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatsRequested>(_onLoadChatsRequested);
    on<LoadMessagesRequested>(_onLoadMessagesRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<UploadImageRequested>(_onUploadImageRequested);
  }

  void _onLoadChatsRequested(
    LoadChatsRequested event,
    Emitter<ChatState> emit,
  ) {
    _chatsSubscription?.cancel();
    emit(ChatLoading());
    _chatsSubscription = getChatsUseCase.call(NoParams()).listen(
      (either) {
        either.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (chats) => emit(ChatLoaded(chats: chats)),
        );
      },
      onError: (error) => emit(ChatError(message: error.toString())),
    );
  }

  void _onLoadMessagesRequested(
    LoadMessagesRequested event,
    Emitter<ChatState> emit,
  ) {
    _messagesSubscription?.cancel();
    emit(MessagesLoading());
    _messagesSubscription = getMessagesUseCase.call(GetMessagesParams(
      senderUid: event.senderUid,
      receiverUid: event.receiverUid,
    )).listen(
      (either) {
        either.fold(
          (failure) => emit(MessagesError(message: failure.message)),
          (messages) => emit(MessagesLoaded(messages: messages)),
        );
      },
      onError: (error) => emit(MessagesError(message: error.toString())),
    );
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessageSending());
    final result = await sendMessageUseCase.call(SendMessageParams(
      senderID: event.senderID,
      receiverID: event.receiverID,
      message: event.message,
      imageUrl: event.imageUrl,
    ));
    result.fold(
      (failure) => emit(MessageSendError(message: failure.message)),
      (_) => emit(MessageSent()),
    );
  }

  Future<void> _onUploadImageRequested(
    UploadImageRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ImageUploading());
    final result = await uploadImageUseCase.call(UploadImageParams(
      imagePath: event.imagePath,
    ));
    result.fold(
      (failure) => emit(ImageUploadError(message: failure.message)),
      (imageUrl) => emit(ImageUploaded(imageUrl: imageUrl)),
    );
  }
}

