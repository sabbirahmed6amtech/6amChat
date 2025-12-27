import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  // Store selected image for preview before sending
  RxnString selectedImageBase64 = RxnString();

  bool get hasSelectedImage => selectedImageBase64.value != null;

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
    _chatUseCase
        .getMessages(chatId)
        .listen(
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

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile == null) {
        print('📸 No image selected');
        return;
      }

      print('📸 Picked file: ${pickedFile.path}');

      // Convert to base64
      final File imageFile = File(pickedFile.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      print('📸 Image converted to base64, length: ${base64Image.length}');

      if (base64Image.length > 10 * 1024 * 1024) {
        // 10MB limit
        Get.snackbar(
          'Error',
          'Image is too large. Please select a smaller image.',
        );
        return;
      }

      // Store image for preview (don't send yet)
      selectedImageBase64.value = base64Image;
      update();
      print('📸 Image ready for preview');
    } catch (e) {
      print('📸 Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void clearSelectedImage() {
    selectedImageBase64.value = null;
    update();
  }

  Future<void> sendMessage(String messageText) async {
    final hasText = messageText.trim().isNotEmpty;
    final hasImage = selectedImageBase64.value != null;

    // Nothing to send
    if (!hasText && !hasImage) return;

    try {
      isSending.value = true;
      update();

      if (hasImage) {
        // Send image message (with optional caption as text)
        await _chatUseCase.sendImageMessage(
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          imageBase64: selectedImageBase64.value!,
          caption: hasText ? messageText.trim() : null,
        );
        // Clear selected image after sending
        selectedImageBase64.value = null;
        print('📸 Image message sent successfully');
      } else {
        // Send text-only message
        await _chatUseCase.sendMessage(
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          message: messageText,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
      update();
    }
  }
}
