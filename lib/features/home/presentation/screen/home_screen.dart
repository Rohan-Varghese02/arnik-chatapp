import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_chats_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/set_user_online_status_usecase.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetChatsUseCase _getChatsUseCase = sl<GetChatsUseCase>();
  final SetUserOnlineStatusUseCase _setUserOnlineStatusUseCase =
      sl<SetUserOnlineStatusUseCase>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _setUserOnlineStatusUseCase.call(
      SetUserOnlineStatusParams(isOnline: true),
    );
  }

  @override
  void dispose() {
    _setUserOnlineStatusUseCase.call(
      SetUserOnlineStatusParams(isOnline: false),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
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
                      onPressed: () async {
                        await _setUserOnlineStatusUseCase.call(
                          SetUserOnlineStatusParams(isOnline: false),
                        );
                        _firebaseAuth.signOut();
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: StreamBuilder(
                    stream: _getChatsUseCase.call(NoParams()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading chats',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade700,
                          ),
                        );
                      }
                      return snapshot.data?.fold(
                        (failure) => Center(
                          child: Text(
                            failure.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        (chats) {
                          if (chats.isEmpty) {
                            return Center(
                              child: Text(
                                'No active chats',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              final chat = chats[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => getChatDetailedPage(
                                        userChatName: chat.name,
                                        userUid: chat.uid,
                                      ),
                                    ),
                                  );
                                },
                                child: ChatTile(
                                  name: chat.name,
                                  lastMessage: chat.lastMessage,
                                  lastMessageTime: chat.lastMessageTime,
                                  photoUrl: chat.photoUrl,
                                ),
                              );
                            },
                          );
                        },
                      ) ??
                          const Center(
                            child: CircularProgressIndicator(),
                          );
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
