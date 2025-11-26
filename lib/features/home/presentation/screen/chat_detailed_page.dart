import 'package:chat_app/features/home/data/datasource/chat_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailedPage extends StatefulWidget {
  final String userChatName;
  final String userUid;
  const ChatDetailedPage({
    super.key,
    required this.userChatName,
    required this.userUid,
  });

  @override
  State<ChatDetailedPage> createState() => _ChatDetailedPageState();
}

class _ChatDetailedPageState extends State<ChatDetailedPage> {
  final currentUserid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Text(widget.userChatName[0].toUpperCase()),
        ),
        title: Text(widget.userChatName),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: ChatRemoteDatasource().getMessage(
                currentUserid,
                widget.userUid,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Loading'));
                }
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text('Start the conversation'));
                }
                return ListView.builder(itemBuilder: (context,index){
                  return ;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
