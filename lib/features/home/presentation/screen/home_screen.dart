import 'package:chat_app/features/home/data/datasource/chat_remote_datasource.dart';
import 'package:chat_app/features/home/presentation/screen/chat_detailed_page.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('H O M E P A G E', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              firebaseAuth.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: ChatRemoteDatasource().getChat(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Center(child: Text('No active chats'));
            } else {
              final chats = snapshot.data;
              return ListView.builder(
                itemCount: chats!.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatDetailedPage(
                              userChatName: chat.name,
                              userUid: chat.uid,
                            ),
                          ),
                        );
                      },
                      child: ChatTile(name: chat.name),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
