import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/chat_usecase.dart';

class ChatController with ChangeNotifier {
  final ChatUseCase _chatUseCase;

  ChatController(this._chatUseCase);


  final List<MessageEntity> messages = [];

  bool isLoading = false;
  bool isSending = false;
  bool isLoadingMore = false;
  bool hasMoreMessages = true;

  late String chatId;
  late String currentUserId;
  late String currentUserName;

  int _currentPage = 0;
  StreamSubscription? _messageSubscription;

  String? selectedImageBase64;

  bool get hasSelectedImage => selectedImageBase64 != null;


  void initChat({
    required String userId1,
    required String userId2,
    required String userName,
  }) {
    currentUserId = userId1;
    currentUserName = userName;
    chatId = _chatUseCase.generateChatId(userId1, userId2);

    _currentPage = 0;
    messages.clear();
    hasMoreMessages = true;

    fetchMessages();
  }


  void fetchMessages() {
    isLoading = true;
    notifyListeners();

    _messageSubscription?.cancel();
    _messageSubscription = _chatUseCase.getMessages(chatId).listen(
          (messageList) {
        messages
          ..clear()
          ..addAll(messageList);
        isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        isLoading = false;
        notifyListeners();
      },
    );
  }


  void loadMoreMessages() {
    if (isLoadingMore || !hasMoreMessages) return;

    isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final offset = _currentPage * AppConstants.messagesPerPage;

    _chatUseCase
        .getMessagesPaginated(
      chatId,
      limit: AppConstants.messagesPerPage,
      offset: offset,
    )
        .listen(
          (newMessages) {
        if (newMessages.isEmpty) {
          hasMoreMessages = false;
        } else {
          messages.addAll(newMessages);
        }
        isLoadingMore = false;
        notifyListeners();
      },
      onError: (_) {
        isLoadingMore = false;
        notifyListeners();
      },
    );
  }


  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      if (base64Image.length > 10 * 1024 * 1024) {
        _showSnackBar(context, 'Image is too large');
        return;
      }

      selectedImageBase64 = base64Image;
      notifyListeners();
    } catch (_) {
      _showSnackBar(context, 'Failed to pick image');
    }
  }

  void clearSelectedImage() {
    selectedImageBase64 = null;
    notifyListeners();
  }


  Future<void> sendMessage(
      String messageText,
      BuildContext context,
      ) async {
    final hasText = messageText.trim().isNotEmpty;
    final hasImage = selectedImageBase64 != null;

    if (!hasText && !hasImage) return;

    try {
      isSending = true;
      notifyListeners();

      if (hasImage) {
        await _chatUseCase.sendImageMessage(
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          imageBase64: selectedImageBase64!,
          caption: hasText ? messageText.trim() : null,
        );
        selectedImageBase64 = null;
      } else {
        await _chatUseCase.sendMessage(
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          message: messageText,
        );
      }
    } catch (_) {
      _showSnackBar(context, 'Failed to send message');
    } finally {
      isSending = false;
      notifyListeners();
    }
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
