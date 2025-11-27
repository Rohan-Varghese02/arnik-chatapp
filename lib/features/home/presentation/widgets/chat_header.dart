import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String userName;
  final String userUid;
  final Stream<bool>? isOnlineStream;
  final Stream<bool>? isTypingStream;

  const ChatHeader({
    super.key,
    required this.userName,
    required this.userUid,
    this.isOnlineStream,
    this.isTypingStream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
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
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.blue.shade700,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  userName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              if (isOnlineStream != null)
                StreamBuilder<bool>(
                  stream: isOnlineStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final isOnline = snapshot.data == true;
                    return Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isTypingStream != null && isOnlineStream != null)
                  _StatusText(
                    typingStream: isTypingStream!,
                    onlineStream: isOnlineStream!,
                  )
                else if (isTypingStream != null)
                  StreamBuilder<bool>(
                    stream: isTypingStream,
                    builder: (context, snapshot) {
                      final isTyping = snapshot.data ?? false;
                      if (isTyping) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'typing',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                else if (isOnlineStream != null)
                  StreamBuilder<bool>(
                    stream: isOnlineStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      final isOnline = snapshot.data == true;
                      return Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          isOnline ? 'online' : 'offline',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusText extends StatefulWidget {
  final Stream<bool> typingStream;
  final Stream<bool> onlineStream;

  const _StatusText({
    required this.typingStream,
    required this.onlineStream,
  });

  @override
  State<_StatusText> createState() => _StatusTextState();
}

class _StatusTextState extends State<_StatusText> {
  bool? _lastOnlineStatus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.typingStream,
      initialData: false,
      builder: (context, typingSnapshot) {
        final isTyping = typingSnapshot.data ?? false;
        if (isTyping) {
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'typing',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        return StreamBuilder<bool>(
          stream: widget.onlineStream,
          builder: (context, onlineSnapshot) {
            if (onlineSnapshot.hasData) {
              _lastOnlineStatus = onlineSnapshot.data == true;
            }
            final isOnline = _lastOnlineStatus ?? false;
            return Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                isOnline ? 'online' : 'offline',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

