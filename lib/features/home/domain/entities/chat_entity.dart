import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String uid;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? photoUrl;

  const ChatEntity({
    required this.uid,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, name, lastMessage, lastMessageTime, photoUrl];
}

