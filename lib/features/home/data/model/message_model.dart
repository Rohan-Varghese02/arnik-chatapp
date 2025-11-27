import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.senderID,
    required super.senderEmail,
    required super.receiverID,
    required super.message,
    required super.timestamp,
    super.imageUrl,
    super.messageType,
  });

  factory MessageModel.fromFirestore(Map<String, dynamic> doc) {
    final timestamp = doc['timestamp'] as Timestamp;
    return MessageModel(
      senderID: doc['senderID'] ?? '',
      senderEmail: doc['senderEmail'] ?? '',
      receiverID: doc['recieverID'] ?? '',
      message: doc['message'] ?? '',
      timestamp: timestamp.toDate(),
      imageUrl: doc['imageUrl'],
      messageType: doc['messageType'] ?? 'text',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': receiverID,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'messageType': messageType,
    };
  }
}

