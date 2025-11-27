import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final DateTime timestamp;
  final String? imageUrl;
  final String messageType;

  const MessageEntity({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    this.imageUrl,
    this.messageType = 'text',
  });

  @override
  List<Object?> get props => [
        senderID,
        senderEmail,
        receiverID,
        message,
        timestamp,
        imageUrl,
        messageType,
      ];
}

