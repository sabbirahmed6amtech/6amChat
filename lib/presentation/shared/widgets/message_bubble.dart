import 'dart:convert';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isCurrentUser;
  final bool isImage;
  final String? imageBase64;

  const MessageBubble({
    super.key,
    required this.message,
    required this.senderName,
    required this.isCurrentUser,
    this.isImage = false,
    this.imageBase64,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.deepPurple : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            if (isImage && imageBase64 != null)
              GestureDetector(
                onTap: () => _showFullImage(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(imageBase64!),
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[400],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            // Show caption/text if not empty and not just the default image placeholder
            if (message.isNotEmpty && message != '📷 Image')
              Padding(
                padding: EdgeInsets.only(top: isImage ? 8 : 0),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    if (imageBase64 == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.memory(
                  base64Decode(imageBase64!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
