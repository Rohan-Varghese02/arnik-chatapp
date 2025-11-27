import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/home/presentation/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final bool isCurrentUser;
  final String? imageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isCurrentUser,
    this.imageUrl,
  });

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null) ...[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imageUrl: imageUrl!,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 8),
              ],
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.isNotEmpty)
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        color: isCurrentUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: isCurrentUser
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

