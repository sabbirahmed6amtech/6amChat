enum MessageType { text, image }

class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final MessageType messageType;
  final String? imageBase64;

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.imageBase64,
  });

  bool get isImage => messageType == MessageType.image && imageBase64 != null;
}
