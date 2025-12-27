import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart' as domain;

class ChatRepositoryImpl implements domain.ChatRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  String generateChatId(String userId1, String userId2) {
    final ids = [userId1, userId2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return _database.ref('chats/$chatId/messages').onValue.map((event) {
      final messagesMap = event.snapshot.value as Map?;
      if (messagesMap != null) {
        final messagesList = messagesMap.entries.map((e) {
          final data = e.value as Map;
          return MessageEntity(
            id: e.key,
            chatId: chatId,
            senderId: data['senderId'] ?? '',
            senderName: data['senderName'] ?? '',
            message: data['message'] ?? '',
            timestamp:
                DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
          );
        }).toList();
        messagesList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return messagesList;
      }
      return [];
    });
  }

  @override
  Stream<List<MessageEntity>> getMessagesPaginated(
    String chatId, {
    required int limit,
    required int offset,
  }) {
    return _database.ref('chats/$chatId/messages').onValue.map((event) {
      final messagesMap = event.snapshot.value as Map?;
      if (messagesMap != null) {
        final messagesList = messagesMap.entries.map((e) {
          final data = e.value as Map;
          return MessageEntity(
            id: e.key,
            chatId: chatId,
            senderId: data['senderId'] ?? '',
            senderName: data['senderName'] ?? '',
            message: data['message'] ?? '',
            timestamp:
                DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
          );
        }).toList();
        messagesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        
        // Apply pagination
        final totalMessages = messagesList.length;
        final startIndex = (totalMessages - offset - limit).clamp(0, totalMessages);
        final endIndex = (totalMessages - offset).clamp(0, totalMessages);
        
        return messagesList.sublist(startIndex, endIndex);
      }
      return [];
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _database.ref('chats/$chatId/messages').push().set({
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    });
  }
}
