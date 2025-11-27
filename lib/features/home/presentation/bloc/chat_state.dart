import 'package:chat_app/features/home/domain/entities/chat_entity.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;

  const ChatLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatState {
  final String message;

  const MessagesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {}

class MessageSendError extends ChatState {
  final String message;

  const MessageSendError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ImageUploading extends ChatState {}

class ImageUploaded extends ChatState {
  final String imageUrl;

  const ImageUploaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class ImageUploadError extends ChatState {
  final String message;

  const ImageUploadError({required this.message});

  @override
  List<Object?> get props => [message];
}

