import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  // class needs to have sender id, sender email, reciever id, timestamp, message too

  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String message;
  String? uid;
  final Timestamp timestamp;

  MessageData({
    this.uid,
    required this.senderID,
    required this.senderEmail,
    required this.recieverID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageData.fromFirestore(Map<String, dynamic> doc) {
    return MessageData(
      uid: doc['uid'],
      senderID: doc['senderID'],
      senderEmail: doc['senderEmail'],
      recieverID: doc['recieverID'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
}