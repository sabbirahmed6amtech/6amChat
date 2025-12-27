import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class ChatUseCase {
  final ChatRepository _chatRepository;

  ChatUseCase(this._chatRepository);

  // Get messages for a chat
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return _chatRepository.getMessages(chatId);
  }

  // Get paginated messages for a chat
  Stream<List<MessageEntity>> getMessagesPaginated(
    String chatId, {
    required int limit,
    required int offset,
  }) {
    return _chatRepository.getMessagesPaginated(
      chatId,
      limit: limit,
      offset: offset,
    );
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    return await _chatRepository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      message: message,
    );
  }

  // Generate chat ID
  String generateChatId(String userId1, String userId2) {
    return _chatRepository.generateChatId(userId1, userId2);
  }
}
