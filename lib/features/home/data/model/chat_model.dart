import 'package:chat_app/features/home/domain/entities/chat_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.uid,
    required super.name,
    super.lastMessage,
    super.lastMessageTime,
    super.photoUrl,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> doc) {
    Timestamp? lastMessageTime;
    if (doc['lastMessageTime'] != null) {
      lastMessageTime = doc['lastMessageTime'] as Timestamp;
    }
    return ChatModel(
      uid: doc['uid'] ?? '',
      name: doc['name'] ?? '',
      lastMessage: doc['lastMessage'],
      lastMessageTime: lastMessageTime?.toDate(),
      photoUrl: doc['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : null,
      'photoUrl': photoUrl,
    };
  }
}

