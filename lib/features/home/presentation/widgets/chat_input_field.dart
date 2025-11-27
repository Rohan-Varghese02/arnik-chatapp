import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isUploading;
  final VoidCallback onSendMessage;
  final VoidCallback onPickImage;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.isUploading,
    required this.onSendMessage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.attach_file,
                color: Colors.grey.shade700,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: controller,
                enabled: !isUploading,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: isUploading ? 'Uploading image...' : 'Type a message',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isUploading ? null : onSendMessage,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isUploading ? Colors.grey.shade400 : Colors.blue.shade700,
              ),
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

