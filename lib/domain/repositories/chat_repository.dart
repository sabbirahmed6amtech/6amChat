import '../entities/message_entity.dart';

abstract class ChatRepository {
  String generateChatId(String userId1, String userId2);

  Stream<List<MessageEntity>> getMessages(String chatId);

  Stream<List<MessageEntity>> getMessagesPaginated(
    String chatId, {
    required int limit,
    required int offset,
  });

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  });
}
