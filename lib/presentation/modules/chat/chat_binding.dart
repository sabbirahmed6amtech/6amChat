import 'package:get/get.dart';
import '../../../../core/services/service_locator.dart';
import 'chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(getIt<ChatController>());
  }
}
