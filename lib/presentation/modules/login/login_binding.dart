import 'package:get/get.dart';
import '../../../../core/services/service_locator.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(getIt<LoginController>());
  }
}
