class MessageModel {
  final String senderId;
  final String senderName;
  final String message;
  final int timestamp;

  MessageModel({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<dynamic, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? 'Unknown',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
