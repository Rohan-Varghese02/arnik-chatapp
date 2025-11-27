import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatsRequested extends ChatEvent {
  const LoadChatsRequested();
}

class LoadMessagesRequested extends ChatEvent {
  final String senderUid;
  final String receiverUid;

  const LoadMessagesRequested({
    required this.senderUid,
    required this.receiverUid,
  });

  @override
  List<Object?> get props => [senderUid, receiverUid];
}

class SendMessageRequested extends ChatEvent {
  final String senderID;
  final String receiverID;
  final String message;
  final String? imageUrl;

  const SendMessageRequested({
    required this.senderID,
    required this.receiverID,
    required this.message,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [senderID, receiverID, message, imageUrl];
}

class UploadImageRequested extends ChatEvent {
  final String imagePath;

  const UploadImageRequested({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class SetUserOnlineStatusRequested extends ChatEvent {
  final bool isOnline;

  const SetUserOnlineStatusRequested({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}

class SetTypingStatusRequested extends ChatEvent {
  final String receiverId;
  final bool isTyping;

  const SetTypingStatusRequested({
    required this.receiverId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [receiverId, isTyping];
}

