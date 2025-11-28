import 'package:chat_app/features/home/data/datasource/cloudinary_service.dart';
import 'package:chat_app/features/home/data/model/chat_model.dart';
import 'package:chat_app/features/home/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChatRemoteDatasource {
  Stream<List<ChatModel>> getChats();
  Stream<List<MessageModel>> getMessages({
    required String senderUid,
    required String receiverUid,
  });
  Future<void> sendMessage({
    required String senderID,
    required String receiverID,
    required String message,
    String? imageUrl,
  });
  Future<String> uploadImageToCloudinary(String imagePath);
  Stream<bool> getUserOnlineStatus(String userId);
  Stream<bool> getUserTypingStatus({
    required String userId,
    required String currentUserId,
  });
  Future<void> setUserOnlineStatus(bool isOnline);
  Future<void> setTypingStatus({
    required String receiverId,
    required bool isTyping,
  });
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRemoteDatasourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get currentUid => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<ChatModel>> getChats() {
    return firestore
        .collection('Users')
        .where('uid', isNotEqualTo: currentUid)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<ChatModel> chats = [];

          for (var userDoc in snapshot.docs) {
            final userData = userDoc.data();
            final otherUserUid = userData['uid'] as String;

            final chatRoomID = _getChatRoomId(currentUid, otherUserUid);

            final messagesSnapshot = await firestore
                .collection('chat_rooms')
                .doc(chatRoomID)
                .collection('message')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

            String? lastMessage;
            Timestamp? lastMessageTime;
            if (messagesSnapshot.docs.isNotEmpty) {
              final lastMsgData = messagesSnapshot.docs.first.data();
              lastMessage = lastMsgData['message'] as String?;
              lastMessageTime = lastMsgData['timestamp'] as Timestamp?;
            }

            chats.add(ChatModel(
              uid: otherUserUid,
              name: userData['name'] ?? '',
              lastMessage: lastMessage,
              lastMessageTime: lastMessageTime?.toDate(),
              photoUrl: userData['photoUrl'] as String?,
            ));
          }

          chats.sort((a, b) {
            if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
            if (a.lastMessageTime == null) return 1;
            if (b.lastMessageTime == null) return -1;
            return b.lastMessageTime!.compareTo(a.lastMessageTime!);
          });

          return chats;
        });
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String senderUid,
    required String receiverUid,
  }) {
    final chatRoomID = _getChatRoomId(senderUid, receiverUid);
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc.data()))
              .toList();
        });
  }

  @override
  Future<void> sendMessage({
    required String senderID,
    required String receiverID,
    required String message,
    String? imageUrl,
  }) async {
    final chatRoomID = _getChatRoomId(senderID, receiverID);
    final senderEmail = firebaseAuth.currentUser!.email ?? '';

    final messageData = MessageModel(
      senderID: senderID,
      senderEmail: senderEmail,
      receiverID: receiverID,
      message: message,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
      messageType: imageUrl != null ? 'image' : 'text',
    );

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('message')
        .add(messageData.toMap());
  }

  @override
  Future<String> uploadImageToCloudinary(String imagePath) async {
    return await CloudinaryService.uploadImage(imagePath);
  }

  @override
  Stream<bool> getUserOnlineStatus(String userId) {
    return firestore
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return false;
      final data = doc.data();
      if (data == null) return false;
      return data['isOnline'] == true;
    });
  }

  @override
  Stream<bool> getUserTypingStatus({
    required String userId,
    required String currentUserId,
  }) {
    final chatRoomID = _getChatRoomId(userId, currentUserId);
    
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .snapshots()
        .map((doc) {
      final typingData = doc.data()?['typing'] as Map<String, dynamic>?;
      if (typingData == null) return false;
      return typingData[userId] == true;
    });
  }

  @override
  Future<void> setUserOnlineStatus(bool isOnline) async {
    await firestore.collection('Users').doc(currentUid).set({
      'isOnline': isOnline,
      'lastSeen': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> setTypingStatus({
    required String receiverId,
    required bool isTyping,
  }) async {
    final chatRoomID = _getChatRoomId(currentUid, receiverId);
    final docRef = firestore.collection('chat_rooms').doc(chatRoomID);
    final doc = await docRef.get();
    
    if (doc.exists) {
      final currentData = doc.data() as Map<String, dynamic>;
      final typingData = currentData['typing'] as Map<String, dynamic>? ?? {};
      typingData[currentUid] = isTyping;
      await docRef.update({'typing': typingData});
    } else {
      await docRef.set({
        'typing': {
          currentUid: isTyping,
        },
      });
    }
  }

  String _getChatRoomId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }
}
