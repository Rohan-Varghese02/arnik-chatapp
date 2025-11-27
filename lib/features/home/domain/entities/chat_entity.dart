import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String uid;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const ChatEntity({
    required this.uid,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
  });

  @override
  List<Object?> get props => [uid, name, lastMessage, lastMessageTime];
}

