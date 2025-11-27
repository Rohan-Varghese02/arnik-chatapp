import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/home/data/datasource/chat_stream_service.dart';
import 'package:chat_app/features/home/data/service/chat_service.dart';
import 'package:chat_app/features/home/domain/entities/message_entity.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_header.dart';
import 'package:chat_app/features/home/presentation/widgets/chat_input_field.dart';
import 'package:chat_app/features/home/presentation/widgets/messages_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:image_picker/image_picker.dart';

class ChatDetailedPage extends StatefulWidget {
  final String userChatName;
  final String userUid;
  final ChatStreamService chatStreamService;
  final ChatService chatService;
  final FirebaseAuth firebaseAuth;

  const ChatDetailedPage({
    super.key,
    required this.userChatName,
    required this.userUid,
    required this.chatStreamService,
    required this.chatService,
    required this.firebaseAuth,
  });

  @override
  State<ChatDetailedPage> createState() => _ChatDetailedPageState();
}

class _ChatDetailedPageState extends State<ChatDetailedPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.firebaseAuth.currentUser!.uid;
    _msgController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _msgController.removeListener(_onTextChanged);
    _msgController.dispose();
    _scrollController.dispose();
    widget.chatService.stopTyping(widget.userUid);
    widget.chatService.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.chatService.handleTextChanged(
      text: _msgController.text,
      receiverId: widget.userUid,
    );
  }

  Stream<bool> _getOnlineStatusStream() {
    return widget.chatStreamService.getOnlineStatusStream(widget.userUid);
  }

  Stream<bool> _getTypingStatusStream() {
    return widget.chatStreamService.getTypingStatusStream(
      userId: widget.userUid,
      currentUserId: _currentUserId,
    );
  }

  Stream<Either<Failure, List<MessageEntity>>> _getMessagesStream() {
    return widget.chatStreamService.getMessagesStream(
      senderUid: _currentUserId,
      receiverUid: widget.userUid,
    );
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
              ChatHeader(
                userName: widget.userChatName,
                userUid: widget.userUid,
                isOnlineStream: _getOnlineStatusStream(),
                isTypingStream: _getTypingStatusStream(),
              ),
              Expanded(
                child: MessagesStreamBuilder(
                  messagesStream: _getMessagesStream(),
                  currentUserId: _currentUserId,
                  scrollController: _scrollController,
                ),
              ),
              ChatInputField(
                controller: _msgController,
                isUploading: _isUploading,
                onSendMessage: _sendMessage,
                onPickImage: _pickAndSendImage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_msgController.text.trim().isEmpty) return;

    await widget.chatService.sendMessage(
      senderId: _currentUserId,
      receiverId: widget.userUid,
      message: _msgController.text.trim(),
    );
    _msgController.clear();
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isUploading = true;
      });

      final result = await widget.chatService.uploadAndSendImage(
        imagePath: image.path,
        senderId: _currentUserId,
        receiverId: widget.userUid,
      );

      result.fold((failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }, (_) {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
