import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/chat_usecase.dart';

class ChatController extends GetxController {
  final ChatUseCase _chatUseCase;
  
  RxList<MessageEntity> messages = <MessageEntity>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSending = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreMessages = true.obs;
  late String chatId;
  late String currentUserId;
  late String currentUserName;
  int _currentPage = 0;

  ChatController(this._chatUseCase);

  void initChat({
    required String userId1,
    required String userId2,
    required String userName,
  }) {
    currentUserId = userId1;
    currentUserName = userName;
    chatId = _chatUseCase.generateChatId(userId1, userId2);
    _currentPage = 0;
    fetchMessages();
  }

  void fetchMessages() {
    isLoading.value = true;
    update();
    _chatUseCase.getMessages(chatId).listen(
      (messageList) {
        messages.value = messageList;
        isLoading.value = false;
        update();
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to fetch messages');
        update();
      },
    );
  }

  void loadMoreMessages() {
    if (isLoadingMore.value || !hasMoreMessages.value) return;

    print('📜 Loading more messages... Page: ${_currentPage + 1}');
    
    isLoadingMore.value = true;
    update();

    _currentPage++;
    final offset = _currentPage * AppConstants.messagesPerPage;
    print('📜 Offset: $offset, Limit: ${AppConstants.messagesPerPage}');

    _chatUseCase
        .getMessagesPaginated(
          chatId,
          limit: AppConstants.messagesPerPage,
          offset: offset,
        )
        .listen(
          (newMessages) {
            print('📜 Loaded ${newMessages.length} older messages');
            if (newMessages.isEmpty) {
              hasMoreMessages.value = false;
              print('📜 No more messages to load');
            } else {
              messages.addAll(newMessages);
              print('📜 Total messages now: ${messages.length}');
            }
            isLoadingMore.value = false;
            update();
          },
          onError: (error) {
            print('📜 Error loading more messages: $error');
            isLoadingMore.value = false;
            Get.snackbar('Error', 'Failed to load more messages');
            update();
          },
        );
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      isSending.value = true;
      update();
      await _chatUseCase.sendMessage(
        chatId: chatId,
        senderId: currentUserId,
        senderName: currentUserName,
        message: messageText,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
      update();
    }
  }
}
