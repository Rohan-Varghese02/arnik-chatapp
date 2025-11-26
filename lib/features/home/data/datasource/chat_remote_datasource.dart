import 'package:chat_app/features/home/data/model/chat_data.dart';
import 'package:chat_app/features/home/data/model/message_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  Stream<List<ChatData>> getChat() {
    return firestore
        .collection('Users')
        .where('uid', isNotEqualTo: currentUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatData.fromFirestore(doc.data()))
              .toList();
        });
  }
    Stream<List<MessageData>> getMessage(String senderUid, String recieverID) {
    List<String> id = [senderUid, recieverID];
    id.sort();
    String chatRoomID = id.join('_');
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageData.fromFirestore(doc.data()))
              .toList();
        });
  }
}