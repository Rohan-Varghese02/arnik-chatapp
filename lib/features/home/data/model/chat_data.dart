import 'package:cloud_firestore/cloud_firestore.dart';

class ChatData {
  final String uid;
  final String name;
  ChatData({required this.uid, required this.name});
  Map<String, dynamic> toMap() {
    return {'uid': uid};
  }

  factory ChatData.fromFirestore(Map<String, dynamic> doc) {
    return ChatData(uid: doc['uid'] ?? '', name: doc['name'] ?? '');
  }
}