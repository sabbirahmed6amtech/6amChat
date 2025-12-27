import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixamchat/core/constants/app_strings.dart';
import 'chat_controller.dart';
import '../../../presentation/shared/widgets/index.dart';

class ChatView extends StatelessWidget {
  final String recipientName;
  final String recipientId;
  final String currentUserId;
  final String currentUserName;

  const ChatView({
    super.key,
    required this.recipientName,
    required this.recipientId,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messageController = TextEditingController();
    final scrollController = ScrollController();

    controller.initChat(
      userId1: currentUserId,
      userId2: recipientId,
      userName: currentUserName,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(recipientName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const AppLoading();
                }

                if (controller.messages.isEmpty) {
                  return EmptyState(
                    message: AppStrings.noMessages,
                    icon: Icons.message,
                  );
                }

                return Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      itemCount:
                          controller.messages.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.messages.length &&
                            controller.isLoadingMore.value) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final message = controller
                            .messages[controller.messages.length - 1 - index];
                        final isCurrentUser = message.senderId == currentUserId;

                        return MessageBubble(
                          message: message.message,
                          senderName: message.senderName,
                          isCurrentUser: isCurrentUser,
                          isImage: message.isImage,
                          imageBase64: message.imageBase64,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          GetBuilder<ChatController>(
            builder: (controller) {
              return MessageInputField(
                controller: messageController,
                selectedImageBase64: controller.selectedImageBase64.value,
                onRemoveImage: () {
                  controller.clearSelectedImage();
                },
                onSend: () async {
                  await controller.sendMessage(messageController.text);
                  messageController.clear();
                },
                imagePicker: () async {
                  await controller.pickImageFromGallery();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
