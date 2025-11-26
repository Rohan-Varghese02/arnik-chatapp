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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        firebaseAuth.signOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.blue.shade700,
                      ),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
              // Chat List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: StreamBuilder(
                    stream: ChatRemoteDatasource().getChat(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No active chats',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      } else {
                        final chats = snapshot.data;
                        return ListView.builder(
                          itemCount: chats!.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return GestureDetector(
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
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
